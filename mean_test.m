classdef mean_test < handle
    % mean threshold test
    
    properties
        a % alphabet is increasing, a(i)<a(i+1)
        n
        dist
        is_dist
        q % unchanged distribution
        r % changed distribution
        beta % bound on the mean of changed distributions
        mean_p % detection parameter [mean threshold]
        pfa % probability of false alarm
        pd % probability of detection
        pd_av % average probability of detection
        pd_wc % worst case probability of detection
    end
    
    methods
        function obj = mean_test(p,q,beta,mean_th) % p is the probability simplex object
            obj.a = p.a;
            obj.n = p.n;
            obj.dist = p.dist;
            obj.is_dist = p.is_dist;
            obj.q = q;
            p.q = q;
            obj.beta = beta;
            p.beta = beta;
            obj.mean_p = mean_th;
            p.kl_p = mean_th;
        end
        
        function pfa_test(obj)
            obj.pfa = 0;
            for i = 1:obj.n+1
                for j = 1:obj.n+1
                    if obj.is_dist(i,j) == 1
                        if obj.mean(obj.dist(i,j,:)) >= obj.mean_p
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
                        if obj.mean(obj.dist(i,j,:)) >= obj.mean_p
                            obj.pd = obj.pd+obj.pd_elem(obj.dist(i,j,:));
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
        
    end
    
end