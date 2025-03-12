#Generamos una función auxiliar para ver cuáles vértices no se conectan directamente en el grafo
#Función auxiliar para ver cuáles vértices no se conectan directamente en el grafo
function midpoint(B::Vector{String}, i::Int, j::Int)::Bool
    # Entrega un booleano indicando si existe un punto u tal que xuy está en la betweenness B
    V = listvert(B)
    for k in eachindex(V)
        #Para cada trío de vértices distintos verifica si estos tres están en la betweenness
        if V[i] * V[k] * V[j] in B
            return true
        end
    end
    #Si recorrió todos los vértices sin retornar entonces no existe un u tal que xuy está en B
    return false
end

function midpoint(B::Vector{Int64}, i::Int, j::Int)::Bool
    # Entrega un booleano indicando si existe un punto u tal que xuy está en la betweenness B
    v = listvert(B)
    for k in eachindex(v)
        #Para cada trío de vértices distintos verifica si estos tres están en la betweenness
        if v[i] * 100 + v[k] * 10 + v[j] in B
            return true
        end
    end
    #Si recorrió todos los vértices sin retornar entonces no existe un u tal que xuy está en B
    return false
end


function creategraph(B::Vector,symtype)
    #Recibe la betweenness B y entrega el grafo en caso de que sea factible
    modelo, Q, V = quasimetric(B, symtype)
    #Si es infactible no retorna nada
    if Q === nothing
        return nothing
    else
        optimize!(modelo)
        n = length(V) #Cantidad de vértices
        G = DiGraph() #Genera el digrafo
        add_vertices!(G, n) #Crea los vértices en el grafo
        elabels = []  # Lista para las etiquetas de las aristas

        for i in eachindex(V)
            for j in eachindex(V)
                if i != j
                    #Para cada par distinto de vértices agrega la arista con el peso dado por Q
                    add_edge!(G,i,j)
                    push!(elabels,Q[i,j])
                    if midpoint(B, i, j) == true
                        #Si hay un vértice entre estas dos aristas, entonces borra el camino directo
                        rem_edge!(G, i, j)
                        pop!(elabels)
                    end
                end
            end
        end
    end
    # Muestra la cuasimétrica Q
    tiempo_modelo= @elapsed (modelo);
    tiempo_ejecucion = @elapsed (optimize!(modelo));
    println(String("Se tardó $tiempo_modelo segundos en crear el modelo y $tiempo_ejecucion en resolverlo"))
    println(V)
    for i in eachindex(V) #0:length(V)
        println(V[i], Q[i, :])
    end
    # Grafica el grafo
    gplot(G, nodelabel=eachindex(V), edgelabel=elabels, linetype="curve", layout=circular_layout,
        outangle=pi/7, background_color="grey", plot_size=(15cm, 15cm), pad=1cm)
end