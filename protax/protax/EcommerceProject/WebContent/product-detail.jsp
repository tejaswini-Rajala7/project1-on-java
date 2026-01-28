<%@ include file="includes/amazon-header.jsp" %>
<%@ page import="model.Product,java.util.*,model.Review" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
Product product = (Product) request.getAttribute("product");
List<Review> reviews = (List<Review>) request.getAttribute("reviews");
if (reviews == null) reviews = new ArrayList<>();
%>

<style>
/* CRITICAL: Remove ALL CSS-generated rupee symbols on product detail page */
.price::before,
.price::after,
[class*="price"]::before,
[class*="price"]::after,
*::before[class*="price"],
*::after[class*="price"],
#product-price-main::before,
#product-price-main::after,
#delivery-text::before,
#delivery-text::after {
    content: "" !important;
    content: none !important;
    display: none !important;
    visibility: hidden !important;
    width: 0 !important;
    height: 0 !important;
    font-size: 0 !important;
    line-height: 0 !important;
    margin: 0 !important;
    padding: 0 !important;
    opacity: 0 !important;
}

/* Ensure price elements don't have any pseudo-element content */
*[id*="price"]::before,
*[id*="price"]::after {
    content: none !important;
    display: none !important;
}
</style>

<script>
// AGGRESSIVE fix for corrupted rupee symbols on product detail page - RUNS IMMEDIATELY
(function() {
    'use strict';
    
    // Run immediately, even before function definition
    (function immediateFix() {
        if (document.body) {
            const allText = document.body.innerText || document.body.textContent || '';
            if (allText.includes('â') || allText.includes('¹')) {
                // Quick fix for visible elements
                const priceEl = document.getElementById('product-price-main') || document.getElementById('price-value');
                const deliveryEl = document.getElementById('delivery-text') || document.getElementById('delivery-amount');
                
                [priceEl, deliveryEl].forEach(el => {
                    if (el) {
                        let text = el.textContent || el.innerText || '';
                        text = text.replace(/â[\d\s]*¹/g, '').replace(/â¹/g, '').replace(/â/g, '').replace(/¹/g, '');
                        if (text !== (el.textContent || el.innerText || '')) {
                            el.textContent = text;
                        }
                    }
                });
            }
        }
    })();
    
    function cleanRupeeSymbols() {
        // Fix ALL text nodes in the document
        const walker = document.createTreeWalker(
            document.body || document.documentElement,
            NodeFilter.SHOW_TEXT,
            null,
            false
        );
        
        let node;
        const nodesToFix = [];
        while (node = walker.nextNode()) {
            let text = node.textContent || '';
            if (text.includes('â') || text.includes('¹') || text.match(/â[\d\s]*¹/)) {
                nodesToFix.push(node);
            }
        }
        
        // Fix all found nodes
        nodesToFix.forEach(node => {
            let text = node.textContent || '';
            const originalText = text;
            
            // Remove corrupted characters
            text = text.replace(/â[\d\s]*¹/g, '');
            text = text.replace(/â¹/g, '');
            text = text.replace(/â/g, '');
            text = text.replace(/¹/g, '');
            text = text.replace(/\s+/g, ' ').trim();
            
            if (text !== originalText) {
                node.textContent = text;
            }
        });
        
        // Fix specific elements by ID - more aggressive
        const priceValueEl = document.getElementById('price-value');
        if (priceValueEl) {
            let text = priceValueEl.textContent || priceValueEl.innerText || '';
            const originalText = text;
            // Remove corrupted characters
            text = text.replace(/â[\d\s]*¹/g, '');
            text = text.replace(/â¹/g, '');
            text = text.replace(/â/g, '');
            text = text.replace(/¹/g, '');
            // Ensure only one ₹ symbol
            const rupeeCount = (text.match(/₹/g) || []).length;
            if (rupeeCount > 1) {
                text = text.replace(/₹/g, '');
                const firstNum = text.search(/\d/);
                if (firstNum !== -1) {
                    text = '₹' + text.substring(firstNum);
                }
            }
            if (text !== originalText) {
                priceValueEl.textContent = text.trim();
            }
        }
        
        const priceEl = document.getElementById('product-price-main');
        if (priceEl) {
            let text = priceEl.textContent || priceEl.innerText || '';
            if (text.includes('â') || text.includes('¹')) {
                text = text.replace(/â[\d\s]*¹/g, '');
                text = text.replace(/â¹/g, '');
                text = text.replace(/â/g, '');
                text = text.replace(/¹/g, '');
                const priceMatch = text.match(/₹?\s*(\d+\.?\d*)/);
                if (priceMatch) {
                    priceEl.innerHTML = '<span id="price-value" style="position: relative; z-index: 1; display: inline-block;">₹' + priceMatch[1] + '</span>';
                }
            }
        }
        
        const deliveryAmountEl = document.getElementById('delivery-amount');
        if (deliveryAmountEl) {
            let text = deliveryAmountEl.textContent || deliveryAmountEl.innerText || '';
            if (text.includes('â') || text.includes('¹')) {
                text = text.replace(/â[\d\s]*¹/g, '');
                text = text.replace(/â¹/g, '');
                text = text.replace(/â/g, '');
                text = text.replace(/¹/g, '');
                if (!text.includes('₹')) {
                    text = '₹' + text.replace(/\D/g, '');
                }
                deliveryAmountEl.textContent = text;
            }
        }
        
        const deliveryEl = document.getElementById('delivery-text');
        if (deliveryEl) {
            let text = deliveryEl.textContent || deliveryEl.innerText || '';
            if (text.includes('â') || text.includes('¹')) {
                text = text.replace(/â[\d\s]*¹/g, '');
                text = text.replace(/â¹/g, '');
                text = text.replace(/â/g, '');
                text = text.replace(/¹/g, '');
                if (!text.includes('₹500') && text.includes('500')) {
                    text = text.replace(/500/g, '₹500');
                }
                deliveryEl.innerHTML = text;
            }
        }
        
        // Fix all elements with price-related classes
        document.querySelectorAll('[class*="price"], [id*="price"], span, div, p').forEach(el => {
            if (el.tagName === 'SCRIPT' || el.tagName === 'STYLE') return;
            
            let text = el.textContent || el.innerText || '';
            if (text.includes('â') || text.includes('¹')) {
                const originalText = text;
                text = text.replace(/â[\d\s]*¹/g, '');
                text = text.replace(/â¹/g, '');
                text = text.replace(/â/g, '');
                text = text.replace(/¹/g, '');
                text = text.replace(/\s+/g, ' ').trim();
                
                if (text !== originalText && el.childNodes.length <= 1) {
                    el.textContent = text;
                }
            }
        });
    }
    
    // Run immediately (even before DOM ready)
    if (document.body) {
        cleanRupeeSymbols();
    }
    
    // Run on DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', cleanRupeeSymbols);
    } else {
        cleanRupeeSymbols();
    }
    
    // Run multiple times with delays
    setTimeout(cleanRupeeSymbols, 10);
    setTimeout(cleanRupeeSymbols, 50);
    setTimeout(cleanRupeeSymbols, 100);
    setTimeout(cleanRupeeSymbols, 300);
    setTimeout(cleanRupeeSymbols, 500);
    setTimeout(cleanRupeeSymbols, 1000);
    setTimeout(cleanRupeeSymbols, 2000);
    
    // Watch for any changes
    if (typeof MutationObserver !== 'undefined' && document.body) {
        const observer = new MutationObserver(function() {
            setTimeout(cleanRupeeSymbols, 10);
        });
        observer.observe(document.body, {
            childList: true,
            subtree: true,
            characterData: true
        });
    }
})();
</script>

</div>
<!-- Close amazon-main-container from header -->

<div class="amazon-main-container">
<div class="amazon-product-section" style="margin-top: 20px;">
<% if (product != null) { %>
<div class="row">
    <div class="col-md-5">
        <%
            String img = product.getImageUrl();
            String imgSrc = null;
            if (img != null && !img.trim().isEmpty()) {
                if (img.startsWith("http://") || img.startsWith("https://")) {
                    imgSrc = img;
                } else if (img.startsWith("/")) {
                    imgSrc = request.getContextPath() + img;
                } else {
                    imgSrc = request.getContextPath() + "/" + img;
                }
            }
        %>
        <div class="amazon-product-image-container" style="height: 500px; max-width: 100%; background: #fff; border: 1px solid #ddd; border-radius: 8px; padding: 20px; margin-bottom: 20px;">
            <% if (imgSrc != null) { %>
            <img src="<%=imgSrc%>" 
                 class="amazon-product-image" alt="<%=product.getName()%>" style="max-height: 100%; width: 100%; object-fit: contain; cursor: zoom-in;" 
                 onclick="openImageModal('<%=imgSrc%>')">
            <% } else { %>
            <div class="amazon-product-image-placeholder" style="height: 100%; font-size: 5rem;">📦</div>
            <% } %>
        </div>
        <div class="amazon-product-actions" style="display: flex; gap: 10px; flex-wrap: wrap;">
            <button class="btn btn-outline-secondary" onclick="shareProduct()">
                <i class="fas fa-share-alt"></i> Share
            </button>
            <button class="btn btn-outline-secondary" onclick="printProduct()">
                <i class="fas fa-print"></i> Print
            </button>
        </div>
    </div>
    <div class="col-md-7">
        <h1 style="font-size: 1.75rem; font-weight: 400; color: #0f1111; margin-bottom: 10px; line-height: 1.3;"><%=product.getName()%></h1>
        
        <div class="mb-3" style="display: flex; align-items: center; gap: 10px;">
            <div class="amazon-product-rating" style="display: flex; align-items: center; gap: 5px;">
                <span class="amazon-product-stars" style="color: #ffa41c; font-size: 1.1rem;">
                    <% for (int i = 0; i < 5; i++) { %>
                        <i class="fas fa-star<%=i < (int)product.getRating() ? "" : "-o"%>"></i>
                    <% } %>
                </span>
                <a href="#reviews" style="color: #007185; text-decoration: none; font-size: 0.875rem;">
                    (<%=String.format("%.1f", product.getRating())%>) 
                    <% if (reviews != null && !reviews.isEmpty()) { %>
                        <%=reviews.size()%> ratings
                    <% } %>
                </a>
            </div>
        </div>
        
        <div style="border-bottom: 1px solid #e7e7e7; padding-bottom: 15px; margin-bottom: 15px;">
            <div style="display: flex; align-items: baseline; gap: 10px; margin-bottom: 10px;">
                <span style="font-size: 0.875rem; color: #565959;">Price:</span>
                <span style="font-size: 1.75rem; font-weight: 400; color: #0f1111;">₹<%=String.format("%.2f", product.getPrice())%></span>
            </div>
            <div style="font-size: 0.875rem; color: #007600; font-weight: 600;">
                <i class="fas fa-check-circle"></i> Inclusive of all taxes
            </div>
        </div>
        
        <div style="margin-bottom: 20px;">
            <% if (product.getBrand() != null) { %>
                <p style="margin-bottom: 8px; font-size: 0.875rem;">
                    <strong style="color: #565959;">Brand:</strong> 
                    <span style="color: #0f1111;"><%=product.getBrand()%></span>
                </p>
            <% } %>
            
            <% if (product.getCategoryName() != null) { %>
                <p style="margin-bottom: 8px; font-size: 0.875rem;">
                    <strong style="color: #565959;">Category:</strong> 
                    <a href="ProductServlet?category=<%=product.getCategoryId()%>" style="color: #007185; text-decoration: none;">
                        <%=product.getCategoryName()%>
                    </a>
                </p>
            <% } %>
            
            <p style="margin-bottom: 8px; font-size: 0.875rem;">
                <strong style="color: #565959;">Availability:</strong> 
                <% if (product.getStock() > 0) { %>
                    <span style="color: #007600; font-weight: 600;">
                        <i class="fas fa-check-circle"></i> In Stock (<%=product.getStock()%> available)
                    </span>
                <% } else { %>
                    <span style="color: #c7511f; font-weight: 600;">
                        <i class="fas fa-times-circle"></i> Out of Stock
                    </span>
                <% } %>
            </p>
        </div>
        
        <div style="background: #f7f7f7; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
            <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
                <i class="fas fa-truck" style="color: #007185; font-size: 1.2rem;"></i>
                <div>
                    <div style="font-weight: 600; color: #0f1111;">FREE Delivery</div>
                    <div id="delivery-text" style="font-size: 0.875rem; color: #565959;">on orders over <span id="delivery-amount" style="position: relative; z-index: 1; display: inline-block;">₹500</span></div>
                </div>
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-shield-alt" style="color: #007185; font-size: 1.2rem;"></i>
                <div>
                    <div style="font-weight: 600; color: #0f1111;">Secure Transaction</div>
                    <div style="font-size: 0.875rem; color: #565959;">Your payment information is safe</div>
                </div>
            </div>
        </div>
        
        <div style="margin-bottom: 20px;">
            <% if (product.getStock() > 0) { %>
                <form action="cart" method="post" class="d-inline-block" style="margin-right: 10px; margin-bottom: 10px;">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="<%=product.getId()%>">
                    <button type="submit" class="btn btn-warning btn-lg" style="background: #ffd814; border: none; color: #0f1111; font-weight: 600; padding: 10px 40px; border-radius: 20px; min-width: 200px;">
                        <i class="fas fa-cart-plus"></i> Add to Cart
                    </button>
                </form>
            <% } else { %>
                <button class="btn btn-secondary btn-lg" disabled style="margin-right: 10px; margin-bottom: 10px; padding: 10px 40px; border-radius: 20px; min-width: 200px;">Out of Stock</button>
            <% } %>
            
            <form action="wishlist" method="post" class="d-inline-block" style="margin-bottom: 10px;">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="productId" value="<%=product.getId()%>">
                <input type="hidden" name="redirect" value="product-detail?id=<%=product.getId()%>">
                <button type="submit" class="btn btn-outline-secondary btn-lg" style="padding: 10px 30px; border-radius: 20px; min-width: 200px;">
                    <i class="fas fa-heart"></i> Add to Wishlist
                </button>
            </form>
        </div>
        
        <div style="border-top: 1px solid #e7e7e7; padding-top: 15px; margin-top: 20px;">
            <a href="ProductServlet" style="color: #007185; text-decoration: none; font-size: 0.875rem;">
                <i class="fas fa-arrow-left"></i> Back to Products
            </a>
        </div>
    </div>
</div>

<% if (product.getDescription() != null) { %>
<div class="row mt-4">
    <div class="col-12">
        <div style="background: #fff; padding: 20px; border-radius: 8px; border: 1px solid #e7e7e7;">
            <h3 style="font-size: 1.25rem; font-weight: 600; margin-bottom: 15px; color: #0f1111;">About this item</h3>
            <div style="line-height: 1.6; color: #0f1111;">
                <%=product.getDescription().replace("\n", "<br>")%>
            </div>
        </div>
    </div>
</div>
<% } %>

<hr class="my-5" id="reviews">

<div class="row">
    <div class="col-md-8">
        <h3 style="font-size: 1.5rem; font-weight: 600; margin-bottom: 20px; color: #0f1111;">Customer Reviews</h3>
        
        <% if (reviews != null && !reviews.isEmpty()) { 
            // Calculate average rating
            double avgRating = reviews.stream().mapToInt(r -> r.getRating()).average().orElse(0.0);
            int[] ratingCounts = new int[6]; // 0-5
            for (Review r : reviews) {
                ratingCounts[r.getRating()]++;
            }
        %>
        <div style="background: #fff; padding: 20px; border-radius: 8px; border: 1px solid #e7e7e7; margin-bottom: 30px;">
            <div style="display: flex; gap: 30px; align-items: center; margin-bottom: 20px;">
                <div style="text-align: center;">
                    <div style="font-size: 3rem; font-weight: 300; color: #0f1111;"><%=String.format("%.1f", avgRating)%></div>
                    <div class="amazon-product-stars" style="color: #ffa41c; font-size: 1.2rem; margin: 5px 0;">
                        <% for (int i = 0; i < 5; i++) { %>
                            <i class="fas fa-star<%=i < (int)avgRating ? "" : "-o"%>"></i>
                        <% } %>
                    </div>
                    <div style="font-size: 0.875rem; color: #565959;"><%=reviews.size()%> ratings</div>
                </div>
                <div style="flex: 1;">
                    <% for (int i = 5; i >= 1; i--) { 
                        int count = ratingCounts[i];
                        int percentage = reviews.size() > 0 ? (count * 100 / reviews.size()) : 0;
                    %>
                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 5px;">
                        <span style="font-size: 0.875rem; color: #007185; min-width: 40px;"><%=i%> star</span>
                        <div style="flex: 1; height: 8px; background: #e7e7e7; border-radius: 4px; overflow: hidden;">
                            <div style="height: 100%; background: #ffa41c; width: <%=percentage%>%;"></div>
                        </div>
                        <span style="font-size: 0.875rem; color: #565959; min-width: 40px;"><%=count%></span>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
        <% if (reviews.isEmpty()) { %>
            <div style="text-align: center; padding: 40px; background: #f7f7f7; border-radius: 8px;">
                <i class="fas fa-comment-alt" style="font-size: 3rem; color: #cbd5e0; margin-bottom: 15px;"></i>
                <h4 style="color: #565959; margin-bottom: 10px;">No reviews yet</h4>
                <p style="color: #565959;">Be the first to review this product!</p>
            </div>
        <% } else { %>
            <% for (Review review : reviews) { %>
            <div style="background: #fff; padding: 20px; border-radius: 8px; border: 1px solid #e7e7e7; margin-bottom: 20px;">
                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 10px;">
                    <div>
                        <div style="font-weight: 600; color: #0f1111; margin-bottom: 5px;"><%=review.getUserName()%></div>
                        <div style="font-size: 0.875rem; color: #565959;">
                            Verified Purchase
                            <% if (review.getCreatedAt() != null) { %>
                                • <%=review.getCreatedAt().toString().split(" ")[0]%>
                            <% } %>
                        </div>
                    </div>
                    <div class="amazon-product-stars" style="color: #ffa41c;">
                        <% for (int i = 0; i < 5; i++) { %>
                            <i class="fas fa-star<%=i < review.getRating() ? "" : "-o"%>"></i>
                        <% } %>
                    </div>
                </div>
                <div style="color: #0f1111; line-height: 1.6; margin-top: 10px;">
                    <%=review.getComment() != null ? review.getComment().replace("\n", "<br>") : ""%>
                </div>
                <div style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #e7e7e7; display: flex; gap: 15px;">
                    <button class="btn btn-sm btn-link" style="padding: 0; color: #007185; text-decoration: none; font-size: 0.875rem;">
                        Helpful
                    </button>
                    <button class="btn btn-sm btn-link" style="padding: 0; color: #007185; text-decoration: none; font-size: 0.875rem;">
                        Report
                    </button>
                </div>
            </div>
            <% } %>
        <% } %>
        
        <% if (session.getAttribute("userId") != null) { %>
        <div style="background: #fff; padding: 25px; border-radius: 8px; border: 1px solid #e7e7e7; margin-top: 30px;">
            <h4 style="font-size: 1.25rem; font-weight: 600; margin-bottom: 20px; color: #0f1111;">Write a Review</h4>
            <form action="review" method="post">
                <input type="hidden" name="productId" value="<%=product.getId()%>">
                <div style="margin-bottom: 20px;">
                    <label style="display: block; font-weight: 600; margin-bottom: 8px; color: #0f1111;">Your Rating</label>
                    <div id="rating-selector" style="display: flex; gap: 5px; margin-bottom: 10px;">
                        <% for (int i = 5; i >= 1; i--) { %>
                        <i class="fas fa-star rating-star" data-rating="<%=i%>" style="font-size: 2rem; color: #ddd; cursor: pointer; transition: color 0.2s;"></i>
                        <% } %>
                    </div>
                    <input type="hidden" name="rating" id="selected-rating" required>
                    <div id="rating-text" style="font-size: 0.875rem; color: #565959; min-height: 20px;"></div>
                </div>
                <div style="margin-bottom: 20px;">
                    <label style="display: block; font-weight: 600; margin-bottom: 8px; color: #0f1111;">Your Review</label>
                    <textarea name="comment" class="form-control" rows="5" required 
                              style="border: 1px solid #ddd; border-radius: 4px; padding: 10px; width: 100%;"
                              placeholder="Share your experience with this product..."></textarea>
                </div>
                <button type="submit" class="btn btn-warning" style="background: #ffd814; border: none; color: #0f1111; font-weight: 600; padding: 10px 30px; border-radius: 20px;">
                    Submit Review
                </button>
            </form>
        </div>
        <% } %>
        
        <script>
        // Rating selector
        const stars = document.querySelectorAll('.rating-star');
        const ratingInput = document.getElementById('selected-rating');
        const ratingText = document.getElementById('rating-text');
        const ratingLabels = {
            1: 'Poor',
            2: 'Fair',
            3: 'Good',
            4: 'Very Good',
            5: 'Excellent'
        };
        
        let selectedRating = 0;
        
        stars.forEach(star => {
            star.addEventListener('mouseenter', function() {
                const rating = parseInt(this.dataset.rating);
                highlightStars(rating);
                ratingText.textContent = ratingLabels[rating];
            });
            
            star.addEventListener('click', function() {
                selectedRating = parseInt(this.dataset.rating);
                ratingInput.value = selectedRating;
                highlightStars(selectedRating);
                ratingText.textContent = ratingLabels[selectedRating];
            });
        });
        
        document.getElementById('rating-selector').addEventListener('mouseleave', function() {
            highlightStars(selectedRating);
            ratingText.textContent = selectedRating > 0 ? ratingLabels[selectedRating] : '';
        });
        
        function highlightStars(rating) {
            stars.forEach((star, index) => {
                if (5 - index <= rating) {
                    star.style.color = '#ffa41c';
                } else {
                    star.style.color = '#ddd';
                }
            });
        }
        
        // Image modal
        function openImageModal(imgSrc) {
            const modal = document.createElement('div');
            modal.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.9); z-index: 10000; display: flex; align-items: center; justify-content: center; cursor: zoom-out;';
            modal.innerHTML = `<img src="${imgSrc}" style="max-width: 90%; max-height: 90%; object-fit: contain;">`;
            modal.onclick = () => modal.remove();
            document.body.appendChild(modal);
        }
        
        function shareProduct() {
            if (navigator.share) {
                navigator.share({
                    title: '<%=product.getName()%>',
                    text: 'Check out this product!',
                    url: window.location.href
                });
            } else {
                navigator.clipboard.writeText(window.location.href);
                alert('Product link copied to clipboard!');
            }
        }
        
        function printProduct() {
            window.print();
        }
        </script>
    </div>
</div>
</div>
<% } else { %>
    <div class="amazon-product-section">
        <div class="alert alert-danger">
            Product not found.
        </div>
    </div>
<% } %>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="includes/footer.jsp" %>
