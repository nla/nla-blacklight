// For blacklight_range_limit built-in JS
// In BL9 / range_limit 9, this is now an ES module loaded via esbuild

import BlacklightRangeLimit from "blacklight-range-limit";

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
