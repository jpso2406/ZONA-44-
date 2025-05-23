/* Author: WebAppLayers
* Product Name: INSPINIA
* Version: 3.0.0
* Purchase: https://wrapbootstrap.com/theme/inspinia-responsive-admin-template-WB0R5L90S?ref=inspinia
* Website: http://www.webapplayers.com
* Contact: webapplayers07@gmail.com
* File Name: inspinia.js
*/



// Minimalize menu
$('.navbar-minimalize').on('click', function (event) {
    event.preventDefault();

    if ($("body").hasClass("canvas-menu")) {
        $("body").toggleClass("menu-open");
    } else {
        $("body").toggleClass("mini-navbar");
    }
    SmoothlyMenu();
});


function SmoothlyMenu() {
    if (!$('body').hasClass('mini-navbar')) {
        // Hide menu in order to smoothly turn on when maximize menu
        $('#side-menu').hide();
        // For smoothly turn on menu
        setTimeout(
            function () {
                $('#side-menu').fadeIn(400);
            }, 200);
    } else if ($('body').hasClass('fixed-sidebar')) {
        $('#side-menu').hide();
        setTimeout(
            function () {
                $('#side-menu').fadeIn(400);
            }, 100);
    } else {
        // Remove all inline style from jquery fadeIn function to reset menu state
        $('#side-menu').removeAttr('style');
    }
}


// For demo purpose - animation css script
function animationHover(element, animation) {
    element = $(element);
    element.hover(
        function () {
            element.addClass('animated ' + animation);
        },
        function () {
            //wait for animation to finish before removing classes
            window.setTimeout(function () {
                element.removeClass('animated ' + animation);
            }, 2000);
        });
}

// Dragable panels
function WinMove() {
    var element = "[class*=col]";
    var handle = ".ibox-title";
    var connect = "[class*=col]";
    $(element).sortable(
        {
            handle: handle,
            connectWith: connect,
            tolerance: 'pointer',
            forcePlaceholderSize: true,
            opacity: 0.8
        })
        .disableSelection();
}



// Collapse ibox function
$('.collapse-link').on('click', function (e) {
    e.preventDefault();
    var ibox = $(this).closest('div.ibox');
    var button = $(this).find('i');
    var content = ibox.children('.ibox-content');
    content.slideToggle(200);
    button.toggleClass('fa-chevron-up').toggleClass('fa-chevron-down');
    ibox.toggleClass('').toggleClass('border-bottom');
    setTimeout(function () {
        ibox.resize();
        ibox.find('[id^=map-]').resize();
    }, 50);
});

// Close ibox function
$('.close-link').on('click', function (e) {
    e.preventDefault();
    var content = $(this).closest('div.ibox');
    content.remove();
});

// Fullscreen ibox function
$('.fullscreen-link').on('click', function (e) {
    e.preventDefault();
    var ibox = $(this).closest('div.ibox');
    var button = $(this).find('i');
    $('body').toggleClass('fullscreen-ibox-mode');
    button.toggleClass('fa-expand').toggleClass('fa-compress');
    ibox.toggleClass('fullscreen');
    setTimeout(function () {
        $(window).trigger('resize');
    }, 100);
});

// Close menu in canvas mode
$('.close-canvas-menu').on('click', function (e) {
    e.preventDefault();
    $("body").toggleClass("menu-open");
    SmoothlyMenu();
});

// Open close right sidebar
$('.right-sidebar-toggle').on('click', function (e) {
    e.preventDefault();
    $('#right-sidebar').toggleClass('sidebar-open');
});


// Open close small chat
$('.open-small-chat').on('click', function (e) {
    e.preventDefault();
    $(this).children().toggleClass('fa-comments').toggleClass('fa-times');
    $('.small-chat-box').toggleClass('active');
});



// Check if the element exists before applying changes
const sidebar = document.querySelector(".sidebar-collapse");

// Simplebar
if (sidebar) {
    sidebar.setAttribute("data-simplebar", "");
    sidebar.classList.add("h-100");
}

// SKIN Select
$('.spin-icon').click(function () {
    $(".theme-config-box").toggleClass("show");
});


// Lucide Icons
lucide.createIcons();

// Popovers
const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]')
const popoverList = [...popoverTriggerList].map(popoverTriggerEl => new bootstrap.Popover(popoverTriggerEl))

// Tooltips
const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))

// offcanvas
const offcanvasElementList = document.querySelectorAll('.offcanvas')
const offcanvasList = [...offcanvasElementList].map(offcanvasEl => new bootstrap.Offcanvas(offcanvasEl))

// Left Sidebar Menu (Vertical Menu)


// Sidebar Active link
var pageUrl = window.location.href.split(/[?#]/)[0];

document.querySelectorAll('.nav.metismenu li a').forEach((element) => {
    if (element.href === pageUrl) {
        element.classList.add('active'); // Add active class to <a>

        let parentLi = element.closest('li'); // Get the closest parent <li>
        if (parentLi) {
            parentLi.classList.add('active'); // Add active class to <li>

            let parentUl = parentLi.closest('ul.nav-second-level'); // Get parent <ul>
            if (parentUl) {
                parentUl.classList.remove('collapse'); // Remove collapse class
                let mainLi = parentUl.closest('li'); // Find the top-level <li>
                if (mainLi) {
                    mainLi.classList.add('active'); // Add active class to main menu item
                }
            }
        }
    }
});

// MetisMenu
var sideMenu = $('#side-menu').metisMenu();

if ($(".navbar-default").length) {

    setTimeout(function () {
        var activatedItem = document.querySelector('li.active .active');
        if (activatedItem != null) {
            var simplebarContent = document.querySelector('.sidebar-collapse .simplebar-content-wrapper');
            var offset = activatedItem.offsetTop - 300;
            if (simplebarContent && offset > 100) {
                scrollTo(simplebarContent, offset, 600);
            }
        }
    }, 200);

    // scrollTo (Left Side Bar Active Menu)
    function easeInOutQuad(t, b, c, d) {
        t /= d / 2;
        if (t < 1) return c / 2 * t * t + b;
        t--;
        return -c / 2 * (t * (t - 2) - 1) + b;
    }
    function scrollTo(element, to, duration) {
        var start = element.scrollTop, change = to - start, currentTime = 0, increment = 20;
        var animateScroll = function () {
            currentTime += increment;
            var val = easeInOutQuad(currentTime, start, change, duration);
            element.scrollTop = val;
            if (currentTime < duration) {
                setTimeout(animateScroll, increment);
            }
        };
        animateScroll();
    }
}


// Form Validation
// Example starter JavaScript for disabling form submissions if there are invalid fields
// Fetch all the forms we want to apply custom Bootstrap validation styles to
// Loop over them and prevent submission
document.querySelectorAll('.needs-validation').forEach(form => {
    form.addEventListener('submit', event => {
        if (!form.checkValidity()) {
            event.preventDefault()
            event.stopPropagation()
        }

        form.classList.add('was-validated')
    }, false)
})



// Add body-small class if window less than 768px
if (window.innerWidth < 769) {
    $('body').addClass('canvas-menu')
} 

// Move right sidebar top after scroll
$(window).scroll(function () {
    if ($(window).scrollTop() > 0 && !$('body').hasClass('fixed-nav')) {
        $('#right-sidebar').addClass('sidebar-top');
    } else {
        $('#right-sidebar').removeClass('sidebar-top');
    }
});

// Minimalize menu when screen is less than 768px
$(window).bind("resize", function () {
    if (window.innerWidth < 769) {
        $('body').addClass('canvas-menu')
    } 
});


// 
//  Layout
// 


// check if browser support HTML5 local storage
function localStorageSupport() {
    return (('localStorage' in window) && window['localStorage'] !== null)
}

document.addEventListener("DOMContentLoaded", function () {
    if (window.innerWidth >= 1140) {


        // Config box
        // Enable/disable fixed top navbar
        $('#fixednavbar').click(function () {
            if ($('#fixednavbar').is(':checked')) {
                $("body").addClass('fixed-nav');
                $("body").removeClass('full-width');
                $("body").removeClass('boxed-layout');
                $('#fixednavbar2').prop('checked', false);
                $('#boxedlayout').prop('checked', false);

                if (localStorageSupport) {
                    localStorage.setItem("fixednavbar", 'on');
                }

                if (localStorageSupport) {
                    localStorage.setItem("fixednavbar2", 'off');
                }
                if (localStorageSupport) {
                    localStorage.setItem("boxedlayout", 'off');
                }
            } else {
                $("body").removeClass('fixed-nav');

                if (localStorageSupport) {
                    localStorage.setItem("fixednavbar", 'off');
                }
            }
        });

        // Enable/disable fixed top navbar
        $('#fixednavbar2').click(function () {
            if ($('#fixednavbar2').is(':checked')) {
                $("body").addClass('full-width');
                $("body").removeClass('boxed-layout');
                $("body").removeClass('fixed-nav');
                $('#boxedlayout').prop('checked', false);
                $('#fixednavbar').prop('checked', false);

                if (localStorageSupport) {
                    localStorage.setItem("fixednavbar2", 'on');
                }

                if (localStorageSupport) {
                    localStorage.setItem("fixednavbar", 'off');
                }

                if (localStorageSupport) {
                    localStorage.setItem("boxedlayout", 'off');
                }
            } else {
                $("body").removeClass('full-width');

                if (localStorageSupport) {
                    localStorage.setItem("fixednavbar2", 'off');
                }
            }
        });

        // Enable/disable fixed sidebar
        $('#fixedsidebar').click(function () {
            if ($('#fixedsidebar').is(':checked')) {
                $("body").addClass('fixed-sidebar');
                $("body").removeClass('mini-navbar');
                $('#collapsemenu').prop('checked', false);

                if (localStorageSupport) {
                    localStorage.setItem("fixedsidebar", 'on');
                }

                if (localStorageSupport) {
                    localStorage.setItem("collapse_menu", 'off');
                }

            } else {
                $('.sidebar-collapse').attr('style', '');
                $("body").removeClass('fixed-sidebar');

                if (localStorageSupport) {
                    localStorage.setItem("fixedsidebar", 'off');
                }

            }
        });

        // Enable/disable collapse menu
        $('#collapsemenu').click(function () {
            if ($('#collapsemenu').is(':checked')) {
                $("body").addClass('mini-navbar');
                $("body").removeClass('fixed-sidebar');
                $('#fixedsidebar').prop('checked', false);
                SmoothlyMenu();

                if (localStorageSupport) {
                    localStorage.setItem("collapse_menu", 'on');
                }

                if (localStorageSupport) {
                    localStorage.setItem("fixedsidebar", 'off');
                }

            } else {
                $("body").removeClass('mini-navbar');
                SmoothlyMenu();

                if (localStorageSupport) {
                    localStorage.setItem("collapse_menu", 'off');
                }
            }
        });

        // Enable/disable boxed layout
        $('#boxedlayout').click(function () {
            if ($('#boxedlayout').is(':checked')) {
                $("body").addClass('boxed-layout');
                $("body").removeClass('fixed-nav');
                $("body").removeClass('full-width');
                $('#fixednavbar').prop('checked', false);
                $('#fixednavbar2').prop('checked', false);

                if (localStorageSupport) {
                    localStorage.setItem("boxedlayout", 'on');
                }

                if (localStorageSupport) {
                    localStorage.setItem("fixednavbar", 'off');
                }

                if (localStorageSupport) {
                    localStorage.setItem("fixednavbar2", 'off');
                }
            } else {
                $("body").removeClass('boxed-layout');

                if (localStorageSupport) {
                    localStorage.setItem("boxedlayout", 'off');
                }
            }
        });

        // Enable/disable fixed footer
        $('#fixedfooter').click(function () {
            if ($('#fixedfooter').is(':checked')) {
                $(".footer").addClass('fixed');

                if (localStorageSupport) {
                    localStorage.setItem("fixedfooter", 'on');
                }
            } else {
                $(".footer").removeClass('fixed');

                if (localStorageSupport) {
                    localStorage.setItem("fixedfooter", 'off');
                }
            }
        });

        if (localStorageSupport) {
            var collapse = localStorage.getItem("collapse_menu");
            var fixedsidebar = localStorage.getItem("fixedsidebar");
            var fixednavbar = localStorage.getItem("fixednavbar");
            var fixednavbar2 = localStorage.getItem("fixednavbar2");
            var boxedlayout = localStorage.getItem("boxedlayout");
            var fixedfooter = localStorage.getItem("fixedfooter");

            if (collapse == 'on') {
                $('#collapsemenu').prop('checked', 'checked')
            }
            if (fixedsidebar == 'on') {
                $('#fixedsidebar').prop('checked', 'checked')
            }
            if (fixednavbar == 'on') {
                $('#fixednavbar').prop('checked', 'checked')
            }
            if (fixednavbar2 == 'on') {
                $('#fixednavbar2').prop('checked', 'checked')
            }
            if (boxedlayout == 'on') {
                $('#boxedlayout').prop('checked', 'checked')
            }
            if (fixedfooter == 'on') {
                $('#fixedfooter').prop('checked', 'checked')
            }
        }



        // Local Storage functions
        // Set proper body class and plugins based on user configuration
        $(document).ready(function () {
            if (localStorageSupport()) {

                var collapse = localStorage.getItem("collapse_menu");
                var fixedsidebar = localStorage.getItem("fixedsidebar");
                var fixednavbar = localStorage.getItem("fixednavbar");
                var fixednavbar2 = localStorage.getItem("fixednavbar2");
                var boxedlayout = localStorage.getItem("boxedlayout");
                var fixedfooter = localStorage.getItem("fixedfooter");

                var body = $('body');

                if (collapse == 'on') {
                    body.addClass('mini-navbar');
                }

                if (fixedsidebar == 'on') {
                    body.addClass('fixed-sidebar');
                }

                if (fixednavbar == 'on') {
                    body.addClass('fixed-nav');
                }

                if (fixednavbar2 == 'on') {
                    body.addClass('full-width');
                }

                if (boxedlayout == 'on') {
                    body.addClass('boxed-layout');
                }

                if (fixedfooter == 'on') {
                    $(".footer").addClass('fixed');
                }
            }
        });
    }
});

// Function to apply the saved theme
function applyTheme(theme) {
    $("body").removeClass("skin-default skin-material skin-light").addClass(theme);
}

// Load and apply the saved theme on page load
$(document).ready(function () {
    let savedTheme = localStorage.getItem("selectedTheme");
    if (savedTheme) {
        applyTheme(savedTheme);
    }
});

// Theme selection and localStorage update
$('.default-skin').click(function () {
    $("body").removeClass("skin-material skin-light");
    localStorage.removeItem("selectedTheme"); // Remove stored theme
});


$('.skin-material').click(function () {
    let theme = "skin-material";
    applyTheme(theme);
    localStorage.setItem("selectedTheme", theme);
});

$('.skin-light').click(function () {
    let theme = "skin-light";
    applyTheme(theme);
    localStorage.setItem("selectedTheme", theme);
});
