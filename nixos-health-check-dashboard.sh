#!/bin/bash

# Add this function to your existing health check script
generate_interactive_dashboard() {
    echo "Generating interactive web dashboard..."

    # Run comprehensive health check and capture data
    local health_data=$(generate_health_data)
    local html_file="/tmp/nixos-health-$(date +%Y%m%d-%H%M%S).html"

    # Generate the HTML dashboard
    generate_html_dashboard "$html_file"

    # Inject real data into the dashboard
    inject_health_data "$html_file" "$health_data"

    echo "✅ Dashboard generated: $html_file"
}

inject_health_data() {
    local html_file="$1"
    local health_data="$2"

    # This function would parse the health data and update the HTML
    # with real values from your system check

    # Example: Update system information
    sed -i "s|23.11.20231213.2e38f74|$(nixos-version 2>/dev/null || echo 'Unknown')|g" "$html_file"
    sed -i "s|6.1.52|$(uname -r)|g" "$html_file"
    sed -i "s|nixos-machine|$(hostname)|g" "$html_file"

    # Update resource usage
    local memory_used=$(free | awk 'NR==2{printf "%.0f", $3/$2*100}')
    local disk_used=$(df / --output=pcent | tail -1 | tr -d ' %')

    sed -i "s|id=\"memoryStat\">--</div>|id=\"memoryStat\">${memory_used}%</div>|g" "$html_file"
    sed -i "s|id=\"diskStat\">--</div>|id=\"diskStat\">${disk_used}%</div>|g" "$html_file"

    # Update status badges based on actual conditions
    local failed_services=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
    if [ "$failed_services" -gt 0 ]; then
        sed -i "s|status-healthy|status-warning|g" "$html_file"
        sed -i "s|Healthy|${failed_services} Issues|g" "$html_file"
    fi
}

# Add to your main script's options
case "${1:-}" in
    "--dashboard"|"-d")
        generate_interactive_dashboard
        ;;
    "--web"|"-w")
        generate_html_dashboard "$2"
        ;;
    # ... other cases
esac
