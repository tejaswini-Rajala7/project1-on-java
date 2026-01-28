package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;

@WebFilter("/*")
public class LoggingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        long start = System.currentTimeMillis();
        HttpServletRequest req = (HttpServletRequest) request;
        
        // Ensure UTF-8 encoding to prevent rupee symbol corruption
        if (response instanceof jakarta.servlet.http.HttpServletResponse) {
            jakarta.servlet.http.HttpServletResponse httpResponse = (jakarta.servlet.http.HttpServletResponse) response;
            httpResponse.setCharacterEncoding("UTF-8");
            if (httpResponse.getContentType() == null || !httpResponse.getContentType().contains("charset")) {
                httpResponse.setContentType("text/html; charset=UTF-8");
            }
        }
        request.setCharacterEncoding("UTF-8");
        
        try {
            chain.doFilter(request, response);
        } finally {
            long duration = System.currentTimeMillis() - start;
            System.out.println("[REQUEST] " + req.getMethod() + " " + req.getRequestURI() + " took " + duration + "ms");
        }
    }
}
