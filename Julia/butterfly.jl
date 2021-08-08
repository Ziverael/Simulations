#Krzysztof Jankowski
using Plots
gr()#backend supporting that 
#Task1
#Butterfly curve
col=LinRange(0,12pi,1000)
r(θ)=exp(sin(θ))-2cos(4*θ)+sin((2*θ-pi)/24)^5
angle=collect(LinRange(0,12pi,1000))
xs=r.(angle).*cos.(angle)
ys=r.(angle).*sin.(angle)

an=@animate for i in 1:length(xs)
    plot(xs[1:i],ys[1:i],
    legend=false,
    line_z=col,
    color=:lighttest,
    background_color=:black,
    framestyle=:none,
    linewidth=2,
    xlims=(-5,5),
    ylims=(-4,4))
end
gif(an,"Butterfly.gif",fps=120)
#https://docs.juliaplots.org/latest/generated/gr/#gr-examples

an=@animate for i in 1:length(xs)
    plot(xs[1:i],ys[1:i],
    proj=:polar,
    line_z=col,
    color=:lighttest,
    background_color=:black,
    linewidth=2,
    legend=false,
    framestyle=:none,
    xlims=(-5,5),
    ylims=(-4,4))
end#rotate to get flower
gif(an,"Butterfly_polar.gif",fps=120) 
#https://docs.juliaplots.org/latest/generated/colorschemes/