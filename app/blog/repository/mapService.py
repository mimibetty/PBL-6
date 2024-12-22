from typing import List
from sqlalchemy import func
from sqlalchemy.orm import Session
from blog import models, schemas
from fastapi import HTTPException, status
import math
import itertools
from collections import defaultdict
from geopy.geocoders import Nominatim
from ortools.constraint_solver import routing_enums_pb2
from ortools.constraint_solver import pywrapcp


def get_coordinate(location: str):
    """
    Get the (latitude, longitude) coordinates from the location name using geopy.

    Args:
        location (str): The name of the location.

    Returns:
        tuple: (latitude, longitude)
    """
    geolocator = Nominatim(user_agent="my_agent")
    try:
        location_data = geolocator.geocode(location)
        if location_data:
            return (location_data.latitude, location_data.longitude)
        else:
            raise ValueError(f"Không tìm thấy tọa độ cho địa điểm: {location}.")
    except Exception as e:
        raise Exception(f"Lỗi khi lấy tọa độ cho '{location}': {str(e)}")


def haversine_distance(lat1, lon1, lat2, lon2):
    """
    Calculate the Haversine distance between two geographic coordinates.

    Args:
        lat1, lon1, lat2, lon2 (float): Coordinates in decimal degrees.

    Returns:
        float: Distance in kilometers.
    """
    R = 6371  # Radius of the Earth in km

    # Convert degrees to radians
    lat1_rad, lon1_rad, lat2_rad, lon2_rad = map(math.radians, [lat1, lon1, lat2, lon2])

    # Haversine formula
    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad
    a = math.sin(dlat / 2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(dlon / 2)**2
    c = 2 * math.asin(math.sqrt(a))

    return R * c


def get_distance_of_2_locations(latlong1, latlong2):
    """
    Get the distance between two coordinates using the Haversine formula.

    Args:
        latlong1, latlong2 (tuple): (latitude, longitude)

    Returns:
        float: Distance in kilometers.
    """
    try:
        distance = haversine_distance(latlong1[0], latlong1[1], latlong2[0], latlong2[1])
        return distance
    except Exception as e:
        raise Exception(f"Lỗi khi tính khoảng cách: {str(e)}")


def get_distances_between_all_locations(locations):
    """
    Generate a symmetric distance matrix for all locations.

    Args:
        locations (list of tuple): List of (latitude, longitude) coordinates.

    Returns:
        list of list of float: Distance matrix.
    """
    n = len(locations)
    distances = [[0] * n for _ in range(n)]  # Initialize n x n matrix

    for i in range(n):
        for j in range(i + 1, n):  # Calculate each pair only once
            if distances[i][j] == 0:
                distance = get_distance_of_2_locations(locations[i], locations[j])
                distances[i][j] = distance
                distances[j][i] = distance
    return distances