classdef glr_test < handle
    % generalized likelihood ratio test is executed
    
    properties
        a % alphabet is increasing, a(i)<a(i+1)
        n
        dist
        is_dist
        q % unchanged distribution
        r % changed distribution
        beta
        proj % M-projection!!! not I-projection!!!
        glr_p % detection parameter [threshold]
        pfa % probability of false alarm
        pd % probability of detection
        pd_av % average probability of detection
        pd_wc % worst case probability of detection
    end
    
    methods
        function obj = glr_test(p,q,beta,th) % p is the probability simplex object
            obj.a = p.a;
            obj.n = p.n;
            obj.dist = p.dist;
            obj.is_dist = p.is_dist;
            obj.q = q;
            p.q = q;
            obj.beta = beta;
            p.beta = beta;
            obj.glr_p = th; % th is a threshold for the generalized likelihood ratio test
            p.glr_p = th;
        end
        
        function pfa_test(obj)
            obj.pfa = 0;
            count = 0;
            for i = 1:obj.n+1
                for j = 1:obj.n+1
                    if obj.is_dist(i,j) == 1
                        if obj.glr_elem(obj.dist(i,j,:))
                            obj.pfa = obj.pfa+obj.pfa_elem(obj.dist(i,j,:));
                            count = count+1
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
        function pd_test_av(obj) % uniform average of pd over changed detections
            obj.pd_av = 0;
            count = 0;
            for i = 1:obj.n+1
                for j = 1:obj.n+1
                    if obj.is_dist(i,j) == 1
                        if obj.mean(obj.dist(i,j,:)) >= obj.beta
                            d = obj.dist(i,j,:);
                            obj.r = d(:); % to change the dimension from 1x1x3
                            obj.pd_test_ch()
                            obj.pd_av = obj.pd_av+obj.pd;
                            count = count+1;
                            count
                        end
                        
                    end
                    
                end
                
            end
            
            obj.pd_av = obj.pd_av/count;
        end
        
        function pd_test_wc(obj)
            obj.pd_wc = inf;
            for i = 1:obj.n+1
                for j = 1:obj.n+1
                    if obj.is_dist(i,j) == 1
                        if obj.mean(obj.dist(i,j,:)) >= obj.beta
                            d = obj.dist(i,j,:);
                            obj.r = d(:); % to change the dimension from 1x1x3
                            obj.pd_test_ch()
                            obj.pd_wc = min(obj.pd,obj.pd_wc);
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
        function pd_test_ch(obj) % pd test per changed distribution
            obj.pd = 0;
            for i = 1:obj.n+1
                for j = 1:obj.n+1
                    if obj.is_dist(i,j) == 1
                        if obj.glr_elem(obj.dist(i,j,:))
                            obj.pd = obj.pd+obj.pd_elem(obj.dist(i,j,:));
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
        function m_proj(obj,p) % approximate m-projection
            if obj.mean(p) >= obj.beta
                obj.proj = p;
            else
                min_dist = inf;
                for i = 1:obj.n+1
                    for j = 1:obj.n+1
                        if obj.is_dist(i,j) == 1
                            if obj.mean(obj.dist(i,j,:)) >= obj.beta
                                d = obj.kl_d(p,obj.dist(i,j,:));
                                if d < min_dist
                                    d2 = obj.dist(i,j,:);
                                    obj.proj = d2(:);
                                    min_dist = d;
                                end
                                
                            end
                            
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
        function d = mean(obj,p)
            d = obj.a'*p(:);
        end
        
        function d = pfa_elem(obj,p_tilde) % pfa per empirical distribution
            d2 = zeros(obj.n,1);
            for i = 1:length(p_tilde)
                d2(round(obj.n*sum(p_tilde(1:i-1)))+1:round(obj.n*sum(p_tilde(1:i)))) = 1:round(obj.n*p_tilde(i)); % debugging rounding error by round()
            end
            
            d = prod((1:obj.n)'./d2); % multinomial coefficient
            d = d*prod(obj.q.^(obj.n*p_tilde(:)));
        end
        
        function d = pd_elem(obj,p_tilde) % pd per changed distribution per empirical distribution
            d2 = zeros(obj.n,1);
            for i = 1:length(p_tilde)
                d2(round(obj.n*sum(p_tilde(1:i-1)))+1:round(obj.n*sum(p_tilde(1:i)))) = 1:round(obj.n*p_tilde(i)); % debugging rounding error by round()
            end
            
            d = prod((1:obj.n)'./d2); % multinomial coefficient
            d = d*prod(obj.r.^(obj.n*p_tilde(:)));
        end
        
        function d = glr_elem(obj,p_tilde) % generalized likelohood ratio test result, 0/1
            obj.m_proj(p_tilde)
            d = prod((obj.proj(:)./obj.q).^(obj.n*p_tilde(:)));
            d = (d >= obj.glr_p);
        end
        
    end
    
    methods (Static)
        function d = kl_d(p,q) % base e
            d = 0;
            for i = 1:length(p)
                if p(i) > 0
                    d = d+p(i)*log(p(i)/q(i));
                end
                
            end
            
        end
        
    end
    
end