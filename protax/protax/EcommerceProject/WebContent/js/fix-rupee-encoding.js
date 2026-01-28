// Fix Rupee Symbol Encoding Issue - Remove corrupted "â¹" characters
(function() {
    'use strict';
    
    function fixRupeeEncoding() {
        // Find all price elements
        const priceElements = document.querySelectorAll('.amazon-product-price, .product-price, .price, [class*="price"]');
        
        priceElements.forEach(el => {
            let text = el.textContent || el.innerText || '';
            
            // Remove corrupted rupee symbol patterns
            // "â¹" is the corrupted UTF-8 representation of ₹
            if (text.includes('â¹') || text.includes('â') || text.match(/â[\d\s]*¹/)) {
                // Remove corrupted characters
                text = text.replace(/â[\d\s]*¹/g, ''); // Remove "â¹" pattern
                text = text.replace(/â/g, ''); // Remove standalone "â"
                text = text.replace(/¹/g, ''); // Remove standalone "¹"
                
                // Clean up any double spaces
                text = text.replace(/\s+/g, ' ').trim();
                
                // Update the element
                el.textContent = text;
            }
            
            // Also check for duplicate ₹ symbols
            const rupeeCount = (text.match(/₹/g) || []).length;
            if (rupeeCount > 1) {
                // Keep only the first ₹ symbol
                text = text.replace(/₹/g, '');
                const firstRupeeIndex = text.search(/\d/);
                if (firstRupeeIndex !== -1) {
                    text = '₹' + text.substring(firstRupeeIndex);
                }
                el.textContent = text;
            }
        });
        
        // Also check all text nodes in price containers
        const containers = document.querySelectorAll('.amazon-product-price-container, .amazon-product-card');
        containers.forEach(container => {
            const walker = document.createTreeWalker(
                container,
                NodeFilter.SHOW_TEXT,
                null,
                false
            );
            
            let node;
            while (node = walker.nextNode()) {
                let text = node.textContent || '';
                if (text.includes('â¹') || text.includes('â') || text.match(/â[\d\s]*¹/)) {
                    text = text.replace(/â[\d\s]*¹/g, '');
                    text = text.replace(/â/g, '');
                    text = text.replace(/¹/g, '');
                    text = text.replace(/\s+/g, ' ').trim();
                    node.textContent = text;
                }
            }
        });
    }
    
    // Run immediately
    fixRupeeEncoding();
    
    // Run on DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', fixRupeeEncoding);
    }
    
    // Run after delays to catch dynamically loaded content
    setTimeout(fixRupeeEncoding, 100);
    setTimeout(fixRupeeEncoding, 500);
    setTimeout(fixRupeeEncoding, 1000);
    setTimeout(fixRupeeEncoding, 2000);
    
    // Run when new content is added
    if (typeof MutationObserver !== 'undefined') {
        const observer = new MutationObserver(function(mutations) {
            let shouldFix = false;
            mutations.forEach(function(mutation) {
                if (mutation.addedNodes.length > 0) {
                    mutation.addedNodes.forEach(function(node) {
                        if (node.nodeType === 1) { // Element node
                            if (node.classList && (
                                node.classList.contains('amazon-product-card') ||
                                node.classList.contains('amazon-product-price') ||
                                node.querySelector('.amazon-product-price')
                            )) {
                                shouldFix = true;
                            }
                        } else if (node.nodeType === 3) { // Text node
                            if (node.textContent && (node.textContent.includes('â¹') || node.textContent.includes('â'))) {
                                shouldFix = true;
                            }
                        }
                    });
                }
            });
            if (shouldFix) {
                setTimeout(fixRupeeEncoding, 50);
            }
        });
        
        if (document.body) {
            observer.observe(document.body, {
                childList: true,
                subtree: true,
                characterData: true
            });
        }
    }
})();
