import { get_ratings_of_cities, rate_number_dest_of_cities, get_num_dest_by_tags } from "../models/AdminDashboardModel.js";

export default function () {
    const getRatingsOfCities = async () => {
        return await get_ratings_of_cities();
    };
    const rateNumberOfDestOfCities = async () => {
        return await rate_number_dest_of_cities();
    };
    const getNumDestByTags = async () => {
        return await get_num_dest_by_tags();
    };
    return {
        getRatingsOfCities,
        rateNumberOfDestOfCities,
        getNumDestByTags,
    };

    
}