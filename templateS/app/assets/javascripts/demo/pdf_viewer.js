const url = './pdf/example.pdf';
let pdfDoc = null,
    pageNum = 1,
    pageRendering = false,
    pageNumPending = null,
    scale = 1.5,
    zoomRange = 0.25,
    canvas = document.getElementById('the-canvas'),
    ctx = canvas.getContext('2d');

/**
 * Render the PDF page on the canvas.
 */
function renderPage(num) {
    pageRendering = true;

    pdfDoc.getPage(num).then(function (page) {
        const viewport = page.getViewport({ scale });
        canvas.width = viewport.width;
        canvas.height = viewport.height;

        const renderContext = {
            canvasContext: ctx,
            viewport: viewport
        };

        const renderTask = page.render(renderContext);
        renderTask.promise.then(function () {
            pageRendering = false;
            if (pageNumPending !== null) {
                renderPage(pageNumPending);
                pageNumPending = null;
            }
        });
    });

    // Update page number display
    document.getElementById('page_num').value = num;
}

/**
 * If a page is currently rendering, queue the next page. Otherwise, render immediately.
 */
function queueRenderPage(num) {
    if (pageRendering) {
        pageNumPending = num;
    } else {
        renderPage(num);
    }
}

/**
 * Go to the previous page.
 */
function onPrevPage() {
    if (pageNum > 1) {
        pageNum--;
        queueRenderPage(pageNum);
    }
}
document.getElementById('prev').addEventListener('click', onPrevPage);

/**
 * Go to the next page.
 */
function onNextPage() {
    if (pageNum < pdfDoc.numPages) {
        pageNum++;
        queueRenderPage(pageNum);
    }
}
document.getElementById('next').addEventListener('click', onNextPage);

/**
 * Zoom in the PDF.
 */
function onZoomIn() {
    scale += zoomRange;
    queueRenderPage(pageNum);
}
document.getElementById('zoomin').addEventListener('click', onZoomIn);

/**
 * Zoom out the PDF.
 */
function onZoomOut() {
    if (scale > zoomRange) {
        scale -= zoomRange;
        queueRenderPage(pageNum);
    }
}
document.getElementById('zoomout').addEventListener('click', onZoomOut);

/**
 * Reset zoom to default scale.
 */
function onZoomFit() {
    scale = 1;
    queueRenderPage(pageNum);
}
document.getElementById('zoomfit').addEventListener('click', onZoomFit);

/**
 * Load the PDF document.
 */
pdfjsLib.getDocument(url).promise.then(function (pdfDoc_) {
    pdfDoc = pdfDoc_;
    document.getElementById('page_count').textContent = `/ ${pdfDoc.numPages}`;

    document.getElementById('page_num').addEventListener('change', function () {
        const pageNumber = Number(this.value);
        if (pageNumber >= 1 && pageNumber <= pdfDoc.numPages) {
            pageNum = pageNumber;
            queueRenderPage(pageNum);
        }
    });

    // Render the first page
    renderPage(pageNum);
});