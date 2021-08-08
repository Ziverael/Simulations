using Plots, PlotThemes
using Random
using BenchmarkTools
using Match
#VARIABLES
#-----------------------
size=20
enrd=0.8
n=6000
fr=200
#=
LEGEND
-1-border
 0-void
 2-235U
 1-238U
 3-n

 neutron representation NamedTuple
 (pos=(x,y,z),vel=(vx,vy,vz))
=#

#FUNCTIONS
#-----------------------
function setatoms!(n::Int64,spc::SubArray{Int64})
    for i in 1:n
        if rand()>enrd
            spc[i]=1
        else
            spc[i]=2
        end
    end
    shuffle!(spc)
end

function setatoms2!(n::Int64,spc::Matrix)
    while n>0
    x,y,z=rand(1:size,3)
    if spc[x,y]==0
        if rand()<enrd
            spc[x,y]=2 
        else
            spc[x,y]=1
        end
    n-=1
    else continue
    end
    end
end

function dirctn(dim::Int64)
    v=rand(-1:1,dim)
    if all(==(0),v)
        v[1]=rand((-1,1))
        shuffle!(v)
    end
    return Tuple(v)
end

function decay2d(x::Tuple,del::Vector{Int64},i::Int64)#::Vector{NamedTuple{(:vel,:pos),Tuple{Tuple,Tuple}}})
    set_n2d!(x,i)
    push!(del,i)
    n=rand(1:3)
    append!(nlist,[((x),dirctn(2)) for _ in 1:n])
end

function set_n2d!(npos::Tuple{Int64,Int64},it::Int64)
    x,y=npos #Add z arg
    spc[x,y]=3
    nlist[it]=((x,y),nlist[it][2])
end

function move2d!()
    del=Vector{Int64}()
    for i in eachindex(nlist)
        spc[nlist[i][1][1],nlist[i][1][2]]=0
        buff=nlist[i][1].+nlist[i][2]#Move neutron
        x,y=buff#Pass also z arg
        ###ACTION###
            @match spc[x,y] begin
            -1||1=>push!(del,i)
            2=>decay2d(buff,del,i)
            _=>set_n2d!(buff,i)
            end
    end
    del=reverse(del)
    for i in del
        deleteat!(nlist,i)
    end
end

function set_n3d!(npos::Tuple{Int64,Int64,Int64},it::Int64)
    x,y,z=npos
    spc[x,y,z]=3
    nlist[it]=((x,y,z),nlist[it][2])
end


function decay3d(x::Tuple,del::Vector{Int64},i::Int64,time::Int64)#::Vector{NamedTuple{(:vel,:pos),Tuple{Tuple,Tuple}}})
    set_n3d!(x,i)
    push!(del,i)
    n=rand(1:3)
    append!(nlist,[((x),dirctn(3)) for _ in 1:n])
    deleteat!(u235list,findfirst(==(x),u235list))
    append!(decaylist,time)
end

function move3d!(time::Int64)
    del=Vector{Int64}()
    for i in eachindex(nlist)
        spc[nlist[i][1][1],nlist[i][1][2],nlist[i][1][3]]=0#scavenge last postion of the neutron
        buff=nlist[i][1].+nlist[i][2]#Move neutron
        x,y,z=buff
        ###ACTION###
            @match spc[x,y,z] begin
            -1||1=>push!(del,i)
            2=>decay3d(buff,del,i,time)
            _=>set_n3d!(buff,i)
            end
    end
    del=reverse(del)
    for i in del
        deleteat!(nlist,i)
    end
end


#SET 2D
#-----------------------
#=
spc=fill(-1,size+2,size+2,)
spc[2:end-1,2:end-1].=0
setatoms!(n,@view spc[2:end-1,2:end-1])
nlist=[((div(size,2),div(size,2)),dirctn(2))]

=#
#ANIMATION 2D
#-----------------------

#=
an=@animate for _ in 1:500
    move2d!()
    surface(@view spc[2:end-1,2:end-1])
end
gif(an,"Decay.gif",fps=8)
=#

#SET 3D
#-----------------------
spc=fill(-1,size+2,size+2,size+2)
spc[2:end-1,2:end-1,2:end-1].=0
setatoms!(n,@view spc[2:end-1,2:end-1,2:end-1])

nlist=[((div(size,2),div(size,2),div(size,2)),dirctn(3))]
u235list=[(i[1],i[2],i[3]) for i in findall(==(2),spc)]
u238list=findall(==(1),spc)
decaylist=Vector{Int64}()

###238U###
xs2=[i[1] for i in u238list]
ys2=[i[2] for i in u238list]
zs2=[i[3] for i in u238list]

#ANIMATION 3D
#-----------------------
gr()
theme(:dark)
campos=[1,30]
move=1
an=@animate for tick in 1:fr
    move3d!(tick)

    ###NEUTRONS###
    xs=[i[1][1] for i in nlist]
    ys=[i[1][2] for i in nlist]
    zs=[i[1][3] for i in nlist]
    ###235U###
    xs1=[i[1] for i in u235list]
    ys1=[i[2] for i in u235list]
    zs1=[i[3] for i in u235list]
    
    ###CAMERA MANIPULATION###
    if (campos[1]>=90 || campos[1]<=0)
        move*=-1
    end
    campos[1]+=move

    ###PLOT###
    scatter3d([xs,xs1,xs2],[ys,ys1,ys2],[zs,zs1,zs2],
    lims=(1,size+2),
    label=["n" "U235" "U238"],
    camera=(campos),
    markersize=6,
    markerstrokewidth=0)
end
#print(decaylist)
print(length(decaylist))
gif(an,"Decay3D.gif",fps=5)
#BENCHMARK
#-----------------------
#@benchmark dirctn(3) 
#@benchmark setatoms!(n,@view spc[2:end-1,2:end-1]) 
#@benchmark (decay((1,4)))
#@benchmark move!(4)