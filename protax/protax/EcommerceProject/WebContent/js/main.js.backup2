// Main JavaScript file for dynamic interactions and animations

(function() {
    'use strict';

    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
        initNavbar();
        initScrollAnimations();
        initFormAnimations();
        initButtonRipples();
        initImageZoom();
        initScrollIndicator();
        initToastNotifications();
        initLoadingStates();
        initParallaxEffects();
        initProductCardAnimations();
        initCartAnimations();
    });

    // Navbar scroll effect
    function initNavbar() {
        const navbar = document.querySelector('.navbar');
        if (!navbar) return;

        let lastScroll = 0;
        window.addEventListener('scroll', function() {
            const currentScroll = window.pageYOffset;
            
            if (currentScroll > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
            
            lastScroll = currentScroll;
        });
    }

    // Scroll animations for elements
    function initScrollAnimations() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        // Observe all cards and sections
        document.querySelectorAll('.card, .cart-item, .page-header').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(el);
        });
    }

    // Form input animations
    function initFormAnimations() {
        const inputs = document.querySelectorAll('.form-control, .form-select');
        
        inputs.forEach(input => {
            // Floating label effect
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('focused');
            });

            input.addEventListener('blur', function() {
                if (!this.value) {
                    this.parentElement.classList.remove('focused');
                }
            });

            // Check if input has value on load
            if (input.value) {
                input.parentElement.classList.add('focused');
            }

            // Real-time validation feedback
            input.addEventListener('input', function() {
                if (this.checkValidity()) {
                    this.style.borderColor = '#27ae60';
                } else {
                    this.style.borderColor = '#e74c3c';
                }
            });
        });

        // Form submission with loading state
        const forms = document.querySelectorAll('form');
        forms.forEach(form => {
            form.addEventListener('submit', function(e) {
                const submitBtn = form.querySelector('button[type="submit"], input[type="submit"]');
                if (submitBtn && !form.dataset.noLoading) {
                    submitBtn.disabled = true;
                    const originalText = submitBtn.innerHTML;
                    submitBtn.innerHTML = '<span class="loading-spinner"></span> Processing...';
                    
                    // Re-enable after 5 seconds as fallback
                    setTimeout(() => {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = originalText;
                    }, 5000);
                }
            });
        });
    }

    // Button ripple effect
    function initButtonRipples() {
        const buttons = document.querySelectorAll('.btn');
        
        buttons.forEach(button => {
            button.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.width = ripple.style.height = size + 'px';
                ripple.style.left = x + 'px';
                ripple.style.top = y + 'px';
                ripple.classList.add('ripple');
                
                this.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });
    }

    // Image zoom effect
    function initImageZoom() {
        const images = document.querySelectorAll('.product-image, .img-fluid');
        
        images.forEach(img => {
            const container = document.createElement('div');
            container.className = 'img-zoom-container';
            img.parentNode.insertBefore(container, img);
            container.appendChild(img);
        });
    }

    // Scroll progress indicator
    function initScrollIndicator() {
        const indicator = document.createElement('div');
        indicator.className = 'scroll-indicator';
        document.body.appendChild(indicator);
        
        window.addEventListener('scroll', function() {
            const winScroll = document.body.scrollTop || document.documentElement.scrollTop;
            const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            const scrolled = (winScroll / height) * 100;
            indicator.style.width = scrolled + '%';
        });
    }

    // Toast notification system
    function initToastNotifications() {
        window.showToast = function(message, type = 'info') {
            const toastContainer = document.querySelector('.toast-container') || createToastContainer();
            const toast = document.createElement('div');
            toast.className = `toast toast-${type}`;
            
            const icons = {
                success: '<i class="fas fa-check-circle text-success"></i>',
                error: '<i class="fas fa-exclamation-circle text-danger"></i>',
                info: '<i class="fas fa-info-circle text-info"></i>',
                warning: '<i class="fas fa-exclamation-triangle text-warning"></i>'
            };
            
            toast.innerHTML = `
                ${icons[type] || icons.info}
                <span style="margin-left: 10px;">${message}</span>
                <button type="button" class="btn-close" style="float: right; background: none; border: none; font-size: 1.2rem; cursor: pointer;">&times;</button>
            `;
            
            toastContainer.appendChild(toast);
            
            // Auto remove after 5 seconds
            setTimeout(() => {
                toast.style.animation = 'slideOutRight 0.5s ease-out';
                setTimeout(() => toast.remove(), 500);
            }, 5000);
            
            // Close button
            toast.querySelector('.btn-close').addEventListener('click', () => {
                toast.style.animation = 'slideOutRight 0.5s ease-out';
                setTimeout(() => toast.remove(), 500);
            });
        };
        
        function createToastContainer() {
            const container = document.createElement('div');
            container.className = 'toast-container';
            document.body.appendChild(container);
            return container;
        }
    }

    // Loading states for async operations
    function initLoadingStates() {
        // Add loading overlay function
        window.showLoading = function() {
            const overlay = document.createElement('div');
            overlay.id = 'loading-overlay';
            overlay.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.7);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 99999;
            `;
            overlay.innerHTML = `
                <div style="text-align: center; color: white;">
                    <div class="loading-spinner" style="width: 50px; height: 50px; border-width: 5px; margin: 0 auto 20px;"></div>
                    <p>Loading...</p>
                </div>
            `;
            document.body.appendChild(overlay);
        };
        
        window.hideLoading = function() {
            const overlay = document.getElementById('loading-overlay');
            if (overlay) overlay.remove();
        };
    }

    // Parallax effects
    function initParallaxEffects() {
        const parallaxElements = document.querySelectorAll('.page-header');
        
        window.addEventListener('scroll', function() {
            const scrolled = window.pageYOffset;
            
            parallaxElements.forEach(element => {
                const rate = scrolled * 0.5;
                element.style.transform = `translateY(${rate}px)`;
            });
        });
    }

    // Product card animations
    function initProductCardAnimations() {
        const productCards = document.querySelectorAll('.product-card');
        
        productCards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
            
            // Add hover sound effect (optional - can be removed)
            card.addEventListener('mouseenter', function() {
                this.style.transition = 'all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
            });
        });
    }

    // Cart animations
    function initCartAnimations() {
        // Animate cart items on load
        const cartItems = document.querySelectorAll('.cart-item');
        cartItems.forEach((item, index) => {
            item.style.animationDelay = `${index * 0.1}s`;
        });

        // Quantity input animations
        const quantityInputs = document.querySelectorAll('input[name="quantity"]');
        quantityInputs.forEach(input => {
            input.addEventListener('change', function() {
                this.style.transform = 'scale(1.1)';
                setTimeout(() => {
                    this.style.transform = 'scale(1)';
                }, 200);
            });
        });
    }

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href !== '#' && href.length > 1) {
                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }
        });
    });

    // Add ripple effect CSS
    const style = document.createElement('style');
    style.textContent = `
        .btn {
            position: relative;
            overflow: hidden;
        }
        .ripple {
            position: absolute;
            border-radius: 50%;
            background: rgba(255,255,255,0.6);
            transform: scale(0);
            animation: ripple-animation 0.6s ease-out;
            pointer-events: none;
        }
        @keyframes ripple-animation {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
        @keyframes slideOutRight {
            from {
                opacity: 1;
                transform: translateX(0);
            }
            to {
                opacity: 0;
                transform: translateX(100px);
            }
        }
        .toast {
            display: flex;
            align-items: center;
            padding: 15px 20px;
        }
    `;
    document.head.appendChild(style);

    // Handle AJAX form submissions with animations
    document.querySelectorAll('form[data-ajax="true"]').forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const action = this.action;
            const method = this.method || 'POST';
            
            showLoading();
            
            fetch(action, {
                method: method,
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                hideLoading();
                if (data.success) {
                    showToast(data.message || 'Operation successful!', 'success');
                    if (data.redirect) {
                        setTimeout(() => {
                            window.location.href = data.redirect;
                        }, 1500);
                    }
                } else {
                    showToast(data.message || 'An error occurred', 'error');
                }
            })
            .catch(error => {
                hideLoading();
                showToast('Network error. Please try again.', 'error');
            });
        });
    });

    // Add to cart animation
    window.addToCartAnimation = function(productId) {
        const productCard = document.querySelector(`[data-product-id="${productId}"]`);
        if (productCard) {
            const button = productCard.querySelector('.btn-primary');
            if (button) {
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-check"></i> Added!';
                button.style.background = 'linear-gradient(135deg, #27ae60 0%, #2ecc71 100%)';
                
                setTimeout(() => {
                    button.innerHTML = originalText;
                    button.style.background = '';
                }, 2000);
            }
        }
    };

    // Wishlist animation
    window.addToWishlistAnimation = function(button) {
        const icon = button.querySelector('i');
        if (icon) {
            icon.classList.remove('fa-heart');
            icon.classList.add('fa-heart', 'fas');
            button.style.transform = 'scale(1.3)';
            button.style.color = '#e74c3c';
            
            setTimeout(() => {
                button.style.transform = 'scale(1)';
            }, 300);
        }
    };

    // Search with debounce
    let searchTimeout;
    const searchInputs = document.querySelectorAll('input[name="q"], input[type="search"]');
    searchInputs.forEach(input => {
        input.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                // Auto-submit search after 500ms of no typing
                if (this.value.length >= 3 || this.value.length === 0) {
                    const form = this.closest('form');
                    if (form) {
                        form.submit();
                    }
                }
            }, 500);
        });
    });

    console.log('✨ Protax Store UI Enhanced - All animations loaded!');
})();
