import { ref, onMounted, watch, nextTick } from 'vue';
import { useToast } from "vue-toastification";
import SignInModel from '../models/SignInModel';
import { getMap } from '../models/mapModel';

export async function getMapbyID(destinationID) {
    try {
        const data = await getMap(destinationID);
        return data.map((item) => ({
            latitude: item.latitude,
            longitude: item.longitude,
        }));
    } catch (error) {
        console.error('Error in getMapbyID:', error);
        return [];
    }
}