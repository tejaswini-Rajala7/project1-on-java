// Image Error Handler - Fallback to placeholder if image fails to load

document.addEventListener('DOMContentLoaded', function() {
    // Handle all product images
    const productImages = document.querySelectorAll('.amazon-product-image');
    
    productImages.forEach(img => {
        img.addEventListener('error', function() {
            // Hide the broken image
            this.style.display = 'none';
            
            // Show placeholder if it exists
            const container = this.closest('.amazon-product-image-container');
            if (container) {
                let placeholder = container.querySelector('.amazon-product-image-placeholder');
                if (!placeholder) {
                    placeholder = document.createElement('div');
                    placeholder.className = 'amazon-product-image-placeholder';
                    placeholder.innerHTML = '📦';
                    container.appendChild(placeholder);
                }
                placeholder.style.display = 'flex';
            }
        });
        
        // Check if image src is empty or invalid
        if (!img.src || img.src === window.location.href || img.src.includes('undefined') || img.src.includes('null')) {
            img.dispatchEvent(new Event('error'));
        }
    });
    
    // Preload images to check if they exist
    productImages.forEach(img => {
        if (img.src && !img.src.includes('placeholder') && !img.src.includes('undefined')) {
            const testImg = new Image();
            testImg.onerror = function() {
                img.dispatchEvent(new Event('error'));
            };
            testImg.src = img.src;
        }
    });
});
