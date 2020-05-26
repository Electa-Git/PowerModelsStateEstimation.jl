using Statistics

function calculate_vm_error(se_sol::Dict, pf_sol::Dict)
    if haskey(se_sol, "solution")
        se_sol = se_sol["solution"]
    end
    if haskey(pf_sol, "solution")
        pf_sol = pf_sol["solution"]
    end

    if haskey(pf_sol["bus"]["1"], "vr")
        convert_rectangular_to_polar!(pf_sol["bus"])
    end
    if haskey(se_sol["bus"]["1"], "vr")
        convert_rectangular_to_polar!(se_sol["bus"])
    end
    vm_diff = []
    for (b,bus) in pf_sol["bus"]
        for cond_vm in 1:length(bus["vm"])
            push!(vm_diff, abs(bus["vm"][cond_vm]-se_sol["bus"][b]["vm"][cond_vm]))
        end
    end
    return vm_diff, maximum(vm_diff), mean(vm_diff)
end

function convert_rectangular_to_polar!(sol::Dict{String,Any})
    for (_,bus) in sol
        bus["vm"] = sqrt.(bus["vi"].^2+bus["vr"].^2)
        bus["va"] = [atan(bus["vi"][c]/bus["vr"][c]) for c in 1:3]
    end
    return sol
end
