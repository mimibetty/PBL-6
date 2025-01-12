export default class TagViewModel {
    constructor() {
        // Danh sách các TagModel được sắp xếp đúng thứ tự
        this.svgIcons = [
            new URL('@/assets/svg/tags/food-drink.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/cultural-heritage.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/historic-sites.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/theater-art.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/mountain.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/private-luxury.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/night-light.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/landmark.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/shopping.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/mountain.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/general.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/hotel.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/food-drink.svg', import.meta.url).href,
            new URL('@/assets/svg/tags/hotel.svg', import.meta.url).href,
        ];
    }

    // Lấy danh sách tất cả tags
    getSvgIcons() {
        return this.svgIcons;
        console.log("SVG:",this.svgIcons);
    }
}
