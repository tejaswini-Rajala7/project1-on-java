// Price Formatter - Ensures all prices display in Rupees (₹)
(function() {
    'use strict';
    
    function formatPrices() {
        // Find all elements that might contain prices
        const priceSelectors = [
            '.price',
            '.amazon-product-price',
            '.product-price',
            '[class*="price"]',
            'td.price',
            'strong.price',
            'p.price',
            'span.price'
        ];
        
        priceSelectors.forEach(selector => {
            const elements = document.querySelectorAll(selector);
            elements.forEach(el => {
                // Skip if element has ::before content (CSS might be adding symbols)
                const computedStyle = window.getComputedStyle(el, '::before');
                if (computedStyle.content && computedStyle.content !== 'none' && computedStyle.content !== '""') {
                    // CSS is adding content, skip this element
                    return;
                }
                
                let text = el.textContent || el.innerText || '';
                // Skip if already has ₹ or is not a price
                if (text.includes('₹') || text.includes('Rs') || text.includes('INR') || text.includes('â')) {
                    return;
                }
                
                // Match price patterns: numbers with optional decimals
                const pricePattern = /(\d{1,3}(?:,\d{3})*(?:\.\d{2})?)/g;
                const matches = text.match(pricePattern);
                
                if (matches && matches.length > 0) {
                    // Check if this looks like a price (not a rating, quantity, etc.)
                    const parentText = el.parentElement ? el.parentElement.textContent : '';
                    const isPriceContext = 
                        parentText.includes('Price') ||
                        parentText.includes('Total') ||
                        parentText.includes('Subtotal') ||
                        parentText.includes('Shipping') ||
                        parentText.includes('Discount') ||
                        el.classList.contains('price') ||
                        el.classList.contains('amazon-product-price');
                    
                    if (isPriceContext) {
                        // Replace first number with ₹ + number
                        text = text.replace(pricePattern, (match, p1) => {
                            // Only replace if it's a reasonable price (not a single digit or very small number)
                            if (parseFloat(match.replace(/,/g, '')) >= 1) {
                                return '₹' + match;
                            }
                            return match;
                        });
                        el.textContent = text;
                    }
                }
            });
        });
        
        // Also check text nodes in price-related containers
        const priceContainers = document.querySelectorAll('.amazon-product-price-container, .card-body, .order-summary, [class*="summary"]');
        priceContainers.forEach(container => {
            const walker = document.createTreeWalker(
                container,
                NodeFilter.SHOW_TEXT,
                null,
                false
            );
            
            let node;
            while (node = walker.nextNode()) {
                let text = node.textContent.trim();
                // Skip if already has ₹ or is empty
                if (!text || text.includes('₹') || text.length < 3) continue;
                
                // Match standalone prices
                const priceMatch = text.match(/^(\d{1,3}(?:,\d{3})*(?:\.\d{2})?)$/);
                if (priceMatch) {
                    const parent = node.parentElement;
                    if (parent && (
                        parent.textContent.includes('Price') ||
                        parent.textContent.includes('Total') ||
                        parent.textContent.includes('Subtotal') ||
                        parent.textContent.includes('Shipping')
                    )) {
                        node.textContent = '₹' + text;
                    }
                }
            }
        });
    }
    
    // Run on DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', formatPrices);
    } else {
        formatPrices();
    }
    
    // Also run after a short delay to catch dynamically loaded content
    setTimeout(formatPrices, 500);
    setTimeout(formatPrices, 1000);
})();
