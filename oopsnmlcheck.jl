

using JSON, DataFrames

oopsjson="./test/oops-3dvar/oops.json"

oopsdict=JSON.parsefile(oopsjson)

#oopsml =  oops

oopsnmls = ["nambl_bmatrix",
            "naml_linear_model",
            "naml_nonlinear_model",
            "naml_observations_tlad",
            "naml_oops_write_spec",
            "naml_traj_model",
            "naml_write_analysis"
            ]

cnt0nml = ["fort.4"]


function readnmlfile(file)
    d = Dict{String,Any}()
    io = open(file)
    while !eof(io)
        l = strip(readline(io))
        while !startswith(l,'&')
            l = strip(readline(io))
        end
        key = lstrip(l,'&')
        d[key] = readnml(io)
    end  
    return d    
end 

function readnml(io) 
    d = Dict{String,Any}()
    l = readline(io)
    while !startswith(strip(l),'/')
    
        key,value=split(l,'=')
        key = strip(key)
        d[key] = strip(value,',')
        l = readline(io)
    end 
    return d
end



function compare(d1,d2) 
    df = DataFrame(key=[],nml1=[],nml2=[])
    for (key2,nml) in d1
        nml2 = getkey(d2,key2,missing)
        if !ismissing(nml2)
            for (key,val) in nml
                val2 = get!(d2[key2],key,missing)
                push!(df,[key, val, val2])
                println("$key: $val, $val2")
            end 
        end
    end
    return df
end 

d1 = readnmlfile("test/oops-3dvar/fort.4")
d2 = readnmlfile("test/cnt0-3dvar/fort.4")

df = compare(d1,d2)
