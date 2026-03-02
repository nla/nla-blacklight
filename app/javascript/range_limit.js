// For blacklight_range_limit built-in JS
// In BL9 / range_limit 9, this is now an ES module loaded via esbuild

import BlacklightRangeLimit from "blacklight-range-limit";
import Chart from "chart.js/auto";

// Track all chart instances for dynamic updates
const chartInstances = [];

// Get tick color based on current color scheme
const getTickColor = () => {
  const isDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches;
  return isDarkMode ? '#ffffff' : '#666666';
};

// Set Chart.js global defaults for dark mode support and styling
// This ensures x-axis tick labels are readable in both light and dark modes
const setChartDefaults = () => {
  const tickColor = getTickColor();
  
  Chart.defaults.scales.linear.ticks.color = tickColor;
  Chart.defaults.scales.linear.ticks.font = { size: 16 };
  Chart.defaults.color = tickColor;
};

// Update all existing chart instances when color scheme changes
const updateChartsColorScheme = () => {
  const tickColor = getTickColor();
  
  // Update global defaults for any new charts
  setChartDefaults();
  
  // Update all existing chart instances
  document.querySelectorAll('.blacklight-range-limit-chart').forEach(canvas => {
    const chart = Chart.getChart(canvas);
    if (chart) {
      chart.options.scales.x.ticks.color = tickColor;
      chart.update('none'); // 'none' prevents animation during update
    }
  });
};

// Initialize chart defaults
setChartDefaults();

// Listen for color scheme changes and update existing charts
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', updateChartsColorScheme);

// Initialize the range limit with a fallback onLoad handler
// Blacklight is loaded separately via blacklight/blacklight module
const onLoadHandler = (fn) => {
  if (document.readyState !== 'loading') {
    fn();
  } else {
    document.addEventListener('DOMContentLoaded', fn);
  }
};

BlacklightRangeLimit.init({ onLoadHandler: onLoadHandler });
