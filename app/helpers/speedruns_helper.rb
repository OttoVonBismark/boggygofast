module SpeedrunsHelper
    # Converts Speedrun data into an array, rather than an object.
    def categorize_runs(rcid)
        return Speedrun.where('runcat_id == ?', rcid).to_a
    end
end
