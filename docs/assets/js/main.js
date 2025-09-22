/**
* Template Name: Scout
* Template URL: https://bootstrapmade.com/scout-bootstrap-multipurpose-template/
* Updated: May 05 2025 with Bootstrap v5.3.5
* Author: BootstrapMade.com
* License: https://bootstrapmade.com/license/
*/

(function() {
  // Scroll suave para el botón .btn-getstarted
  document.addEventListener('DOMContentLoaded', function() {
    const btnGetStarted = document.querySelector('.btn-getstarted');
    if (btnGetStarted) {
      btnGetStarted.addEventListener('click', function(e) {
        const contactSection = document.querySelector('#contact');
        if (contactSection) {
          e.preventDefault();
          let scrollMarginTop = getComputedStyle(contactSection).scrollMarginTop;
          window.scrollTo({
            top: contactSection.offsetTop - parseInt(scrollMarginTop),
            behavior: 'smooth'
          });
        }
      });
    }
  });
  // --- Language Selector ---
  document.addEventListener('DOMContentLoaded', function() {
    const langSelects = document.querySelectorAll('.lang-select');
    const selectedLang = document.getElementById('selected-lang');
    const translations = {
      es: {
        Home: 'Inicio',
        About: 'Acerca de',
        Team: 'Equipo',
        'Archivos pdf': 'Archivos pdf',
        Contact: 'Contacto',
        Location: 'Ubicación',
        Email: 'Correo',
        Call: 'Teléfono',
        'Open Hours': 'Horario',
        'Get in Touch': 'Contáctanos',
      },
      en: {
        Home: 'Home',
        About: 'About',
        Team: 'Team',
        'Archivos pdf': 'PDF Files',
        Contact: 'Contact',
        Location: 'Location',
        Email: 'Email',
        Call: 'Call',
        'Open Hours': 'Open Hours',
        'Get in Touch': 'Get in Touch',
      }
    };
    langSelects.forEach(btn => {
      btn.addEventListener('click', function(e) {
        e.preventDefault();
        const lang = this.getAttribute('data-lang');
        selectedLang.textContent = lang.toUpperCase();
        // Menú principal
        document.querySelector('a[href="#hero"]').textContent = translations[lang].Home;
        document.querySelector('a[href="#about"]').textContent = translations[lang].About;
        document.querySelector('a[href="#team"]').textContent = translations[lang].Team;
        document.querySelector('a[href="#contact"]').textContent = translations[lang].Contact;
        // Sección contacto
        let contactLabels = document.querySelectorAll('.contact-card h4');
        if(contactLabels.length >= 4) {
          contactLabels[0].textContent = translations[lang].Location;
          contactLabels[1].textContent = translations[lang].Email;
          contactLabels[2].textContent = translations[lang].Call;
          contactLabels[3].textContent = translations[lang]['Open Hours'];
        }
        // Título contacto
        let contactTitle = document.querySelector('#contact .section-title h2');
        if(contactTitle) contactTitle.textContent = translations[lang].Contact;
        // Get in Touch
        let getInTouch = document.querySelector('.contact-content h3, .contact-content h2');
        if(getInTouch) getInTouch.textContent = translations[lang]['Get in Touch'];
      });
    });
  });
  "use strict";

  /**
   * Apply .scrolled class to the body as the page is scrolled down
   */
  function toggleScrolled() {
    const selectBody = document.querySelector('body');
    const selectHeader = document.querySelector('#header');
    if (!selectHeader.classList.contains('scroll-up-sticky') && !selectHeader.classList.contains('sticky-top') && !selectHeader.classList.contains('fixed-top')) return;
    window.scrollY > 100 ? selectBody.classList.add('scrolled') : selectBody.classList.remove('scrolled');
  }

  document.addEventListener('scroll', toggleScrolled);
  window.addEventListener('load', toggleScrolled);

  /**
   * Mobile nav toggle
   */
  const mobileNavToggleBtn = document.querySelector('.mobile-nav-toggle');

  function mobileNavToogle() {
    document.querySelector('body').classList.toggle('mobile-nav-active');
    mobileNavToggleBtn.classList.toggle('bi-list');
    mobileNavToggleBtn.classList.toggle('bi-x');
  }
  if (mobileNavToggleBtn) {
    mobileNavToggleBtn.addEventListener('click', mobileNavToogle);
  }

  /**
   * Hide mobile nav on same-page/hash links
   */
  document.querySelectorAll('#navmenu a').forEach(navmenu => {
    navmenu.addEventListener('click', () => {
      if (document.querySelector('.mobile-nav-active')) {
        mobileNavToogle();
      }
    });

  });

  /**
   * Toggle mobile nav dropdowns
   */
  document.querySelectorAll('.navmenu .toggle-dropdown').forEach(navmenu => {
    navmenu.addEventListener('click', function(e) {
      e.preventDefault();
      this.parentNode.classList.toggle('active');
      this.parentNode.nextElementSibling.classList.toggle('dropdown-active');
      e.stopImmediatePropagation();
    });
  });

  /**
   * Scroll top button
   */
  let scrollTop = document.querySelector('.scroll-top');

  function toggleScrollTop() {
    if (scrollTop) {
      window.scrollY > 100 ? scrollTop.classList.add('active') : scrollTop.classList.remove('active');
    }
  }
  scrollTop.addEventListener('click', (e) => {
    e.preventDefault();
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  });

  window.addEventListener('load', toggleScrollTop);
  document.addEventListener('scroll', toggleScrollTop);

  /**
   * Animation on scroll function and init
   */
  function aosInit() {
    AOS.init({
      duration: 600,
      easing: 'ease-in-out',
      once: true,
      mirror: false
    });
  }
  window.addEventListener('load', aosInit);

  /**
   * Initiate Pure Counter
   */
  new PureCounter();

  /**
   * Frequently Asked Questions Toggle
   */
  document.querySelectorAll('.faq-item h3, .faq-item .faq-toggle').forEach((faqItem) => {
    faqItem.addEventListener('click', () => {
      faqItem.parentNode.classList.toggle('faq-active');
    });
  });

  /**
   * Init swiper sliders
   */
  function initSwiper() {
    document.querySelectorAll(".init-swiper").forEach(function(swiperElement) {
      let config = JSON.parse(
        swiperElement.querySelector(".swiper-config").innerHTML.trim()
      );

      if (swiperElement.classList.contains("swiper-tab")) {
        initSwiperWithCustomPagination(swiperElement, config);
      } else {
        new Swiper(swiperElement, config);
      }
    });
  }

  window.addEventListener("load", initSwiper);

  /**
   * Correct scrolling position upon page load for URLs containing hash links.
   */
  window.addEventListener('load', function(e) {
    if (window.location.hash) {
      if (document.querySelector(window.location.hash)) {
        setTimeout(() => {
          let section = document.querySelector(window.location.hash);
          let scrollMarginTop = getComputedStyle(section).scrollMarginTop;
          window.scrollTo({
            top: section.offsetTop - parseInt(scrollMarginTop),
            behavior: 'smooth'
          });
        }, 100);
      }
    }
  });

  /**
   * Navmenu Scrollspy
   */
  let navmenulinks = document.querySelectorAll('.navmenu a');

  function navmenuScrollspy() {
    navmenulinks.forEach(navmenulink => {
      if (!navmenulink.hash) return;
      let section = document.querySelector(navmenulink.hash);
      if (!section) return;
      let position = window.scrollY + 200;
      if (position >= section.offsetTop && position <= (section.offsetTop + section.offsetHeight)) {
        document.querySelectorAll('.navmenu a.active').forEach(link => link.classList.remove('active'));
        navmenulink.classList.add('active');
      } else {
        navmenulink.classList.remove('active');
      }
    })
  }
  window.addEventListener('load', navmenuScrollspy);
  document.addEventListener('scroll', navmenuScrollspy);

})();