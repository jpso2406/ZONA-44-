/* Author: WebAppLayers
* Product Name: INSPINIA
* Version: 3.0.0
* Purchase: https://wrapbootstrap.com/theme/inspinia-responsive-admin-template-WB0R5L90S?ref=inspinia
* Website: http://www.webapplayers.com
* Contact: webapplayers07@gmail.com
* File Name: head.js
*/


class ThemeCustomizer {

    theme = "light";

    init() {
        this.html = document.getElementsByTagName('html')[0];

        // Get theme from localStorage
        const config = localStorage.getItem('__THEME_CONFIG__');
        if (config) {
            const parsed = JSON.parse(config);
            this.theme = parsed['theme'];
        }

        this.theme = this.html.getAttribute('data-bs-theme') || this.theme;

        // Apply theme settings
        if (this.theme === 'dark') {
            document.documentElement.setAttribute('data-bs-theme', 'dark');
        } else if (this.theme === 'light') {
            document.documentElement.setAttribute('data-bs-theme', 'light');
        } else {
            document.documentElement.removeAttribute('data-bs-theme'); // Default behavior
        }

        this.onThemeChange();

        window.addEventListener('DOMContentLoaded', () => {
            this.after();
        });
    }

    onThemeChange = () => {
        if (this.theme === 'dark') {
            document.documentElement.setAttribute('data-bs-theme', 'dark');
        } else {
            document.documentElement.setAttribute('data-bs-theme', 'light');
        }

        if (this.lightTheme && this.darkTheme) {
            if (this.theme === 'light') {
                this.lightTheme.classList.remove('d-none');
                this.darkTheme.classList.add('d-none');
            } else {
                this.darkTheme.classList.remove('d-none');
                this.lightTheme.classList.add('d-none');
            }
        }

        localStorage.setItem('__THEME_CONFIG__', JSON.stringify({
            theme: this.theme
        }))
    }

    after() {
        this.lightTheme = document.getElementById('light-theme');
        this.darkTheme = document.getElementById('dark-theme');

        if (this.lightTheme && this.darkTheme) {
            this.lightTheme.addEventListener('click', (e) => {
                this.theme = 'dark';
                this.onThemeChange();
            });
            this.darkTheme.addEventListener('click', (e) => {
                this.theme = 'light';
                this.onThemeChange();
            })
        }
        this.onThemeChange();
    }
}

new ThemeCustomizer().init();

document.addEventListener("DOMContentLoaded", function () {
    if (window.innerWidth <= 1140) {
        document.body.classList.add("canvas-menu");
    }
});