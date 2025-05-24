//



document.addEventListener("DOMContentLoaded", function () {
    "use strict";

    class SimpleMDEEditor {
        constructor() {
            this.init();
        }

        init() {
            new SimpleMDE({
                element: document.getElementById("simplemde1"),
                spellChecker: false,
                autosave: {
                    enabled: false,
                    unique_id: 'simplemde1'
                }
            });
        }
    }

    // Initialize the editor
    new SimpleMDEEditor();
});
