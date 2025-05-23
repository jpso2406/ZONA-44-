





$(document).ready(function () {
    // Apply shave.js to elements with different classes
    shave('.truncate', 70);
    shave('.truncate1', 60, { character: ' ///...' });
    shave('.truncate2', 50);
});