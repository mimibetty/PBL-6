// FilterViewModel.js
import FilterOptionModel from '../models/FilterOptionModel';

export default class FilterViewModel {
    constructor() {
        // Khởi tạo các tùy chọn cho từng nhóm filter
        this.establishmentTypes = [
            new FilterOptionModel('restaurant', 'Restaurant'),
            new FilterOptionModel('coffee-tea', 'Coffee & Tea'),
            new FilterOptionModel('bar-pubs', 'Bar & Pubs'),
            new FilterOptionModel('dessert', 'Dessert'),
            new FilterOptionModel('bakeries', 'Bakeries'),
            new FilterOptionModel('delivery-only', 'Delivery Only'),
        ];

        this.meals = [
            new FilterOptionModel('breakfast', 'Breakfast'),
            new FilterOptionModel('brunch', 'Brunch'),
            new FilterOptionModel('lunch', 'Lunch'),
            new FilterOptionModel('dinner', 'Dinner'),
        ];

        this.propertyTypes = [
            new FilterOptionModel('hotels', 'Hotels'),
            new FilterOptionModel('b&bs & Inns', 'B&Bs & Inns'),
            new FilterOptionModel('specialitty lodgings', 'Specialitty Lodgings'),
            new FilterOptionModel('hostels', 'Hostels'),
            new FilterOptionModel('condos', 'Condos'),
            new FilterOptionModel('lodges', 'Lodges'),
            new FilterOptionModel('villa', 'Villa'),
            new FilterOptionModel('resorts', 'Resorts'),
            new FilterOptionModel('motels', 'Motels'),
            new FilterOptionModel('all-inclusive', 'All-inclusive'),
            new FilterOptionModel('campgrounds', 'Campgrounds'),
            new FilterOptionModel('cottage', 'Cottage'),
            new FilterOptionModel('pensions', 'Pensions'),
            new FilterOptionModel('capsule hotels', 'Capsule Hotels'),
        ];

        this.length_trip = [
            new FilterOptionModel('1', '1 Day'),
            new FilterOptionModel('2', '2 Days'),
            new FilterOptionModel('3', '3 Days'),
            new FilterOptionModel('4', '4 Days'),
            new FilterOptionModel('5', '5 Days'),
            new FilterOptionModel('6', '6 Days'),
            new FilterOptionModel('7', '7 Days'),
        ];

        this.regions = [
            new FilterOptionModel('0', 'Việt Nam'),
            new FilterOptionModel('1', 'Hà Nội'),
            new FilterOptionModel('2', 'TP. Hồ Chí Minh'),
            new FilterOptionModel('3', 'Đà Nẵng'),
            new FilterOptionModel('4', 'Hải Phòng'),
            new FilterOptionModel('5', 'Cần Thơ'),
            new FilterOptionModel('6', 'An Giang'),
            new FilterOptionModel('7', 'Bà Rịa - Vũng Tàu'),
            new FilterOptionModel('8', 'Bắc Giang'),
            new FilterOptionModel('9', 'Bắc Kạn'),
            new FilterOptionModel('10', 'Bạc Liêu'),
            new FilterOptionModel('11', 'Bắc Ninh'),
            new FilterOptionModel('12', 'Bến Tre'),
            new FilterOptionModel('13', 'Bình Định'),
            new FilterOptionModel('14', 'Bình Dương'),
            new FilterOptionModel('15', 'Bình Phước'),
            new FilterOptionModel('16', 'Bình Thuận'),
            new FilterOptionModel('17', 'Cà Mau'),
            new FilterOptionModel('18', 'Cao Bằng'),
            new FilterOptionModel('19', 'Đắk Lắk'),
            new FilterOptionModel('20', 'Đắk Nông'),
            new FilterOptionModel('21', 'Điện Biên'),
            new FilterOptionModel('22', 'Đồng Nai'),
            new FilterOptionModel('23', 'Đồng Tháp'),
            new FilterOptionModel('24', 'Gia Lai'),
            new FilterOptionModel('25', 'Hà Giang'),
            new FilterOptionModel('26', 'Hà Nam'),
            new FilterOptionModel('27', 'Hà Tĩnh'),
            new FilterOptionModel('28', 'Hải Dương'),
            new FilterOptionModel('29', 'Hậu Giang'),
            new FilterOptionModel('30', 'Hòa Bình'),
            new FilterOptionModel('31', 'Hưng Yên'),
            new FilterOptionModel('32', 'Khánh Hòa'),
            new FilterOptionModel('33', 'Kiên Giang'),
            new FilterOptionModel('34', 'Kon Tum'),
            new FilterOptionModel('35', 'Lai Châu'),
            new FilterOptionModel('36', 'Lâm Đồng'),
            new FilterOptionModel('37', 'Lạng Sơn'),
            new FilterOptionModel('38', 'Lào Cai'),
            new FilterOptionModel('39', 'Long An'),
            new FilterOptionModel('40', 'Nam Định'),
            new FilterOptionModel('41', 'Nghệ An'),
            new FilterOptionModel('42', 'Ninh Bình'),
            new FilterOptionModel('43', 'Ninh Thuận'),
            new FilterOptionModel('44', 'Phú Thọ'),
            new FilterOptionModel('45', 'Phú Yên'),
            new FilterOptionModel('46', 'Quảng Bình'),
            new FilterOptionModel('47', 'Quảng Nam'),
            new FilterOptionModel('48', 'Quảng Ngãi'),
            new FilterOptionModel('49', 'Quảng Ninh'),
            new FilterOptionModel('50', 'Quảng Trị'),
            new FilterOptionModel('51', 'Sóc Trăng'),
            new FilterOptionModel('52', 'Sơn La'),
            new FilterOptionModel('53', 'Tây Ninh'),
            new FilterOptionModel('54', 'Thái Bình'),
            new FilterOptionModel('55', 'Thái Nguyên'),
            new FilterOptionModel('56', 'Thanh Hóa'),
            new FilterOptionModel('57', 'Thừa Thiên Huế'),
            new FilterOptionModel('58', 'Tiền Giang'),
            new FilterOptionModel('59', 'Trà Vinh'),
            new FilterOptionModel('60', 'Tuyên Quang'),
            new FilterOptionModel('61', 'Vĩnh Long'),
            new FilterOptionModel('62', 'Vĩnh Phúc'),
            new FilterOptionModel('63', 'Yên Bái'),
        ];
        
        this.selectedRegion = this.regions[0];
        this.selectedLength = this.length_trip[0];

        // Trạng thái hiển thị dropdown (chỉ 1 dropdown trạng thái cho toàn bộ ViewModel)
        this.dropdownVisible_region = false;
        this.dropdownVisible_length = false;

        this.currency = 'VND';
        this.minPrice = 0;
        this.maxPrice = 0;
    }

    // Phương thức toggle chọn/bỏ chọn cho các tùy chọn của Establishment Type
    toggleEstablishmentType(id) {
        const option = this.establishmentTypes.find((item) => item.id === id);
        if (option) option.selected = !option.selected;
    }

    // Phương thức toggle chọn/bỏ chọn cho các tùy chọn của Meals
    toggleMeal(id) {
        const option = this.meals.find((item) => item.id === id);
        if (option) option.selected = !option.selected;
    }

    // Phương thức toggle chọn/bỏ chọn cho các tùy chọn của Property Type
    togglePropertyType(id) {
        const option = this.propertyTypes.find((item) => item.id === id);
        if (option) option.selected = !option.selected;
    }

    // Phương thức cập nhật regionSelected
    updateRegionSelected(id) {
        const selectedOption = this.regions.find((item) => item.id === id);
        if (selectedOption) {
            this.selectedRegion = selectedOption;
        }
    }

    // Phương thức cập nhật selectedLength
    updateSelectedLength(id) {
        const selectedOption = this.length_trip.find((item) => item.id === id);
        if (selectedOption) {
            this.selectedLength = selectedOption;
        }
    }
    
    // Phương thức cập nhật currency
    updateCurrency(currency) {
        this.currency = currency;
    }

    // Phương thức cập nhật giá trị Min và Max Price
    updatePriceRange(minPrice, maxPrice) {
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
    }

    toggleDropDown_region() {
        this.dropdownVisible_region = !this.dropdownVisible_region;
    }

    toggleDropDown_length() {
        this.dropdownVisible_length = !this.dropdownVisible_length;
    }
}
