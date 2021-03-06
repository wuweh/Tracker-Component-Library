function y=solveYuleWalker(r,b)
%%SOLVEYULEWALKER Solve the Yule-Walker equation or the general Yule-Walker
%          equation. For the Yule-Walker equation, given a real positive
%          definite Topeplitz matrix T=toeplitz([1;r(1:n-1)]), solve the
%          system T*y=-r(n-1:-1:1). For the general Yule-Walker equation,
%          given a real Toeplitz matrix T=toeplitz([1;r(1:n-1)]), solve the
%          system T*y=b.
%
%INPUTS: r When solving the Yule-Walker equation, r is a real nX1 or 1Xn
%          vector defining a Toeplitz matrix such that
%          toeplitz([1;r(1:n-1)]) is positive definite. When solving the
%          general Yule-Walker equation, r is an (n-1)X1 or 1X(n-1) vector
%          with similar requirements for the toeplitz matrix.
%        b If this parameter is provided and is not an empty matrix, then
%          the system being solved is T*y=b with T=toeplitz([1;r(1:n-1)]).
%          Otherwise, the system being solved is T*y=-r(n-1:-1:1).
%
%OUTPUTS: y The real solution to the system T*y=-r(n-1:-1:1).
%
%If b is not provided, this uses Durbin's algorithm, which is Algorithm
%4.7.1 in Chapter 4.7.3 of [1]. If b is provided, this uses Levinson's
%algorithm, which is Algorithm 4.7.2 in Chapter 4.7.4 of [1].
%
%REFERENCES:
%[1] G. H. Golub and C. F. Van Loan, Matrix Computations, 4th ed.
%    Baltimore: Johns Hopkins University Press, 2013.
%
%December 2015 David F. Crouse, Naval Research Laboratory, Washington D.C.
%(UNCLASSIFIED) DISTRIBUTION STATEMENT A. Approved for public release.

if(nargin<2||isempty(b))
    %The system is toeplitz([1;r(1:n-1)])*y=-r(n-1:-1:1). Use Durbin's
    %algorithm.
    n=length(r); 
    %Allocate space
    y=zeros(n,1); 
    z=zeros(n,1);

    y(1)=-r(1); 
    beta=1; 
    alpha=-r(1);

    for k=1:(n-1)
        beta=(1-alpha^2)*beta;
        alpha=-(r(k+1)+r(k:-1:1)'*y(1:k))/beta;
        z(1:k)=y(1:k)+alpha*y(k:-1:1);
        y(1:k+1)=[z(1:k);alpha];
    end
else
    %The system is T*x=b. Use Levinson's algorithm.
    n=length(b);
 
    %Allocate space
    y=zeros(n,1); 
    z=zeros(n,1); 
    x=zeros(n,1);
    v=zeros(n,1); 

    y(1)=-r(1); 
    x(1)=b(1); 
    beta=1; 
    alpha=-r(1);
    for k=1:(n-1)
        beta=(1-alpha^2)*beta;
        mu=(b(k+1)-r(1:k)'*x(k:-1:1))/beta;
        v(1:k)=x(1:k)+mu*y(k:-1:1);
        x(1:k+1)=[v(1:k);mu];
        if k<n-1
            alpha=-(r(k+1)+r(1:k)'*y(k:-1:1))/beta;
            z(1:k)=y(1:k)+alpha*y(k:-1:1);
            y(1:k+1)=[z(1:k);alpha];
        end
    end
    y=x;%x is the return value in this instance
end
end

%LICENSE:
%
%The source code is in the public domain and not licensed or under
%copyright. The information and software may be used freely by the public.
%As required by 17 U.S.C. 403, third parties producing copyrighted works
%consisting predominantly of the material produced by U.S. government
%agencies must provide notice with such work(s) identifying the U.S.
%Government material incorporated and stating that such material is not
%subject to copyright protection.
%
%Derived works shall not identify themselves in a manner that implies an
%endorsement by or an affiliation with the Naval Research Laboratory.
%
%RECIPIENT BEARS ALL RISK RELATING TO QUALITY AND PERFORMANCE OF THE
%SOFTWARE AND ANY RELATED MATERIALS, AND AGREES TO INDEMNIFY THE NAVAL
%RESEARCH LABORATORY FOR ALL THIRD-PARTY CLAIMS RESULTING FROM THE ACTIONS
%OF RECIPIENT IN THE USE OF THE SOFTWARE.
