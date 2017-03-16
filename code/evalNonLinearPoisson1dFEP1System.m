% evalNonLinearPoisson1dFEP1System Evaluate the system of nonlinear
% equations yielding by the linear finite elements (FE-P1) method applied to
% the nonlinear one-dimensional Poisson equation $-(v(u) u(x)')' = f(x)$ in
% the unknown $u = u(x)$, $x \in [a,b]$.
% 
% F = evalNonLinearPoisson1dFEP1System(u, h, v, rhs, BCLt, BCRt)
% \param u      point where to evaluate the equations
% \param h      grid size
% \param v      viscosity $v = v(u)$ as handle function
% \param rhs    discretized right-hand side; see getLinearPoisson1dFEP1rhs_f
% \param BCLt   type of left boundary condition:
%               - 'D': Dirichlet
%               - 'N': Neumann
%               - 'P': periodic
% \param BCRt   type of right boundary condition:
%               - 'D': Dirichlet
%               - 'N': Neumann
%               - 'P': periodic
% \out   F      evaluation of the nonlinear system

function F = evalNonLinearPoisson1dFEP1System(u, h, v, rhs, BCLt, BCRt)
    % Some shortcuts
    ul = u(1:end-2);  uc = u(2:end-1);  ur = u(3:end);  
    ulc = 0.5*(ul+uc);  ucr = 0.5*(uc+ur);
    
    % Initialize vector of evaluations
    F = zeros(size(u));

    % Evaluate nonlinear equations associated with internal points of
    % the domain
    F(2:end-1) = (1/(6*h)) * (- (v(ul) + 4*v(ulc) + v(uc)) .* ul ...
       + (v(ul) + 4*v(ulc) + 2*v(uc) + 4*v(ucr) + v(ur)) .* uc ...
       - (v(uc) + 4*v(ucr) + v(ur)) .* ur) - rhs(2:end-1);

    % Evaluate nonlinear equation associated with left boundary
    if strcmp(BCLt,'D')
       F(1) = (1/h) * u(1) - rhs(1);
    elseif strcmp(BCLt,'N')
       F(1) = (1/(6*h)) * ((v(u(1)) + 4*v(0.5*(u(1)+u(2))) + v(u(2))) * ...
           (u(1) - u(2))) - rhs(1);
    elseif strcmp(BCLt,'P')
       F(1) = (1/h) * (u(1) - u(end));
    end

    % Evaluate nonlinear equation associated with right boundary
    if strcmp(BCRt,'D')
       F(end) = (1/h) * u(end) - rhs(end);
    elseif strcmp(BCRt,'N')
       F(end) = (1/(6*h)) * ((v(u(end-1)) + 4*v(0.5*(u(end-1)+u(end))) + v(u(end))) * ...
           (-u(end-1) + u(end))) - rhs(end);
    elseif strcmp(BCRt,'P')
       F(end) = (1/h) * (u(1) - u(end));
    end
end