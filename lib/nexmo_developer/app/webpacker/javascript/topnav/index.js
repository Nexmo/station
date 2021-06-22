export default class Topnav {
  constructor() {
    this.domNode = document.getElementById('subnav');
    this.backdrop = this.domNode.querySelector('.Vlt-header__backdrop');

    this.setupListeners();
  }

  setupListeners() {
    this.domNode.querySelectorAll('.Vlt-tabs__link-menu').forEach((menu) => {
      menu.addEventListener('click', this.toggleMenu.bind(this));
    });

    this.domNode.querySelector('.Adp-header__hamburger').addEventListener('click', this.toggleMobileMenu.bind(this));
  }

  toggleMobileMenu() {
    this.backdrop.classList.toggle('Vlt-header__backdrop-active');
    this.domNode.querySelector('.Adp-header__sub__menu').classList.toggle('Vlt-M-plus');
  }

  toggleMenu(event) {
    let menu   = event.target.closest('.Vlt-tabs__link-menu');
    let active = menu.querySelector('.Vlt-topmenu').classList.contains('Vlt-topmenu-active');

    this.backdrop.classList.toggle('Vlt-header__backdrop-active', !active);

    this.domNode.querySelectorAll('.Vlt-topmenu').forEach((elem) => {
      elem.classList.remove('Vlt-topmenu-active');
    });
    menu.querySelector('.Vlt-topmenu').classList.toggle('Vlt-topmenu-active', !active);
  }
}
