export default {
    data: {
      isScrolled: false,
      activeButton: 'home',  // Default active button
    },
    setActiveButton(buttonName) {
      this.data.activeButton = buttonName;
    },
    setScrollState(state) {
      this.data.isScrolled = state;
    },
  };
  