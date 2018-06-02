classdef lmp_test < handle
    % locally most powerful detection test is executed
    
    properties
        a % alphabet is increasing, a(i)<a(i+1)
        n
        dist
        is_dist
        q % unchanged distribution
        r % changed distribution
        beta
        proj % I-projection
        lmp_p % detection parameters [threshold; KL radius]
        eps = 1e-6 % I-projection error
        pfa % probability of false alarm
        pd % probability of detection
        pd_av % average probability of detection
        pd_wc % worst case probability of detection
    end
    
    methods
        function obj = lmp_test(p,q,beta,dir,th) % p is the probability simplex object
            obj.a = p.a;
            obj.n = p.n;
            obj.dist = p.dist;
            obj.is_dist = p.is_dist;
            obj.q = q;
            p.q = q;
            obj.beta = beta;
            p.beta = beta;
            obj.lmp_p = [dir;th]; % dir is a (normalised) direction vector of dimension |a|
            % th is a threshold for the locally most powerful test
            p.lmp_p = [dir;th];
            obj.i_proj()
        end
        
        function pfa_test(obj)
            obj.pfa = 0;
            for i = 1:obj.n+1
                for j = 1:obj.n+1
                    if obj.is_dist(i,j) == 1
                        if obj.lmp_elem(obj.dist(i,j,:))
                            obj.pfa = obj.pfa+obj.pfa_elem(obj.dist(i,j,:));
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
                        if obj.lmp_elem(obj.dist(i,j,:))
                            obj.pd = obj.pd+obj.pd_elem(obj.dist(i,j,:));
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
        function i_proj(obj)
            obj.proj = obj.q;
            err = (obj.beta-obj.mean(obj.proj))*inf;
            while abs(err)>obj.eps
                obj.proj = obj.proj.*exp(sign(err)*obj.eps*obj.a);
                obj.proj = obj.proj/sum(obj.proj);
                err = obj.beta(1)-obj.mean(obj.proj);
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
        
        function d = lmp_elem(obj,p_tilde) % locally most powerful test result, 0/1
            d = obj.n*sum(p_tilde(:).*log(obj.proj(:)./obj.q(:)))+log(sum(p_tilde(:).*obj.lmp_p(1:end-1)./obj.proj(:)));
            d = (d >= obj.lmp_p(end));
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
