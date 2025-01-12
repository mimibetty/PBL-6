import { ref, onMounted } from 'vue';
import { getTripByID } from '../../models/TripModel';
import { getDestinationById } from '../../models/destinationModel';

export default function (tripId) {

    const trip = ref(null);

    const fetchTrip = async () => {
        // Lấy trip theo tripId
        const selectedTrip = await getTripByID(tripId);

        if (selectedTrip) {
            // Duyệt qua các destination_id trong trip_destinations và lấy thông tin destination
            const destinations = await Promise.all(
                selectedTrip.trip_destinations.map(async (tripDestination) => {
                    const destination = await getDestinationById(tripDestination.destination_id);
                    destination.trip_id = tripDestination.trip_id;
                    destination.order = tripDestination.order;
                    destination.day = tripDestination.day;
                    return destination; // Trả về thông tin destination
                })
            );

            // Thêm mảng destinations vào trip
            selectedTrip.destinations = destinations;
            trip.value = selectedTrip; // Cập nhật trip
            console.log('Trip:', trip.value);
        } else {
            trip.value = null;
        }
    }

    onMounted(() => {
        fetchTrip();
    });

    return {
        trip,
    }
}
