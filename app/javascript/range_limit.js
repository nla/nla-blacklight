// For blacklight_range_limit built-in JS
// In BL9 / range_limit 9, this is now an ES module loaded via esbuild

import BlacklightRangeLimit from "blacklight-range-limit";
// Import Chart from chart.js directly (not chart.js/auto) to match blacklight-range-limit's import
// This ensures we're registering plugins on the same Chart instance
import { Chart } from "chart.js";
import annotationPlugin from "chartjs-plugin-annotation";

// Register the annotation plugin globally
Chart.register(annotationPlugin);

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

// Update the selection annotation on a chart
// This is called from the range slider controller when slider values change
// Grey out the UNSELECTED areas (left and right of the selection)
// sliderMin/sliderMax are the slider's bounds (i.e. the full selectable range)
const updateChartSelection = (canvas, minValue, maxValue, sliderMin, sliderMax) => {
  const chart = Chart.getChart(canvas);
  if (!chart) {
    return;
  }
  
  // Get the chart's actual min/max from its scale
  const chartMin = chart.scales.x.min;
  const chartMax = chart.scales.x.max;
  
  // Check if slider handles are at both extremes of the slider range.
  // This avoids showing overlay borders when the user hasn't narrowed the range,
  // even if the chart scale extends slightly beyond the slider bounds due to padding.
  const isSliderAtFullRange = (sliderMin !== undefined && sliderMax !== undefined)
    ? (minValue <= sliderMin && maxValue >= sliderMax)
    : (minValue <= chartMin && maxValue >= chartMax);
  
  if (!chart.options.plugins.annotation) {
    chart.options.plugins.annotation = { annotations: {} };
  }
  
  if (isSliderAtFullRange) {
    // Remove annotations if full range is selected
    chart.options.plugins.annotation.annotations = {};
  } else {
    const annotations = {};
    const greyOutStyle = {
      type: 'box',
      backgroundColor: 'rgba(128, 128, 128, 0.4)',
      borderColor: 'rgba(104, 94, 87, 0.9)',
      borderWidth: 2
    };
    
    // Left grey-out box (from chart min to selection min)
    if (minValue > chartMin) {
      annotations.leftGreyOut = {
        ...greyOutStyle,
        xMin: chartMin,
        xMax: minValue
      };
    }
    
    // Right grey-out box (from selection max to chart max)
    if (maxValue < chartMax) {
      annotations.rightGreyOut = {
        ...greyOutStyle,
        xMin: maxValue,
        xMax: chartMax
      };
    }
    
    chart.options.plugins.annotation.annotations = annotations;
  }
  
  chart.update('none');
};

// Listen for custom events from the range slider Stimulus controller on chart
// canvas elements. Events bubble up from the canvas, so we use delegation on
// the document to handle dynamically created canvases.
document.addEventListener('range-slider:update', (event) => {
  const canvas = event.target;
  const { minValue, maxValue, sliderMin, sliderMax } = event.detail;
  updateChartSelection(canvas, minValue, maxValue, sliderMin, sliderMax);
});

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
