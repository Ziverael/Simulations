using Plots
using PlotThemes
###VARIABLES###
φ=(sqrt(5)+1)/2
limit=400
sizeval=(2000,2000)
param=[collect(LinRange(0,i,j)) for i in 50:50:limit for j in 50:50:limit]
col=1:limit
###FUNCTIONS###
r(t)=t^φ
θ(t)=2π*φ*t

###SEIRES###
xs=[r.(i).*cos.(i) for i in param]
ys=[r.(i).*sin.(i) for i in param]

###PLOTS###
theme(:dark)
out=plot(xs,ys,layout=(8,8),
legend=false,
size=sizeval,
line_z=col
)

###SAVE FIGURES###
savefig(out,"spiralsNBlooms")


#scatter(xs,ys,framestyle=:none,markershape=:rtriangle,markersize=2,markercolor=:yellow,background_color=:black)
#Note:
# t₀:steps
# 1:1 rought shape bloom
# 1:8 smooth spiral
# 2:1 trianglular shape (especially 100:50)
