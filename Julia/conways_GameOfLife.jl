#Krzysztof Jankowski © All rights reserved
using Plots
#Define matrix
n=30
m=30
t_limit=300
field=rand((0,0,0,0,0,0,0,1),100,100)
#field=Matrix{Bool}(undef,n,m)
#field=[0 0 0 0 0 0;0 0 0 0 0 0;0 0 1 1 1 0;0 1 1 1 0 0;0 0 0 0 0 0;0 0 0 0 0 0]
#field=[0 0 0 0 0 0;0 1 0 0 0 0;0 0 1 1 1 0;0 0 0 0 0 0]


###FUNCTIONS###
function merge(array,rng)
    if array[1]==0
        array[1]=rng
    elseif array[end]>rng
        array[end]=1
end
    
end
#domain i₀∈[1,size(matrix)[1]]
#domain j₀∈[1,size(matrix)[2]]
function state!(matrx,i₀,j₀,out)

    iterx=[i₀-1 i₀ i₀+1]
    itery=[j₀-1 j₀ j₀+1]

    merge(iterx,size(matrx,1))
    merge(itery,size(matrx,2))
    
    buffer=sum(matrx[i,j] for i in iterx for j in itery)-matrx[i₀,j₀]
    if buffer!=2 && buffer!=3
        out[i₀,j₀]=0
    elseif buffer==3 && matrx[i₀,j₀]==0
        out[i₀,j₀]=1
    end
end


###CREATE ANIMATION###
gmol=@animate for k in 1:t_limit
    heatmap(field,
    seriescolor=cgrad([:black,:green]),
    #title="Game of life",
    background_color=:black,
    legend=false,
    ticks=false
    )
    matState=copy(field)
    for i in 1:size(field)[1]
        for j in 1:size(field)[2]
            state!(field,i,j,matState)
        end
    end
    field=matState
end

###DISPLAY###
println("Finished")
gif(gmol,"Conway's game of life.gif",fps=4)
