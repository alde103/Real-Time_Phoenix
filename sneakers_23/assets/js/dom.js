const dom = {}
function getProductIds() {
    const products = document.querySelectorAll('.product-listing')
    return Array.from(products).map((el) => el.dataset.productId)
}
dom.getProductIds = getProductIds

function replaceProductComingSoon(productId, sizeHtml) {
    const name = `.product-soon-${productId}`
    const productSoonEls = document.querySelectorAll(name)
    productSoonEls.forEach((el) => {
        const fragment = document.createRange()
            .createContextualFragment(sizeHtml)
        el.replaceWith(fragment)
    })
}
dom.replaceProductComingSoon = replaceProductComingSoon

export default dom