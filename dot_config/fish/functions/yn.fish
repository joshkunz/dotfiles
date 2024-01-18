function yn --argument prompt
    while true
        read -l -P $prompt' [y/N] ' confirm
        switch $confirm
            case Y y yes Yes YES
                return 0
            case '' N n no No NO
                return 1
        end
        echo "unrecognized option $confirm" >&2
    end
end
