import BlacklightRangeLimit from "blacklight-range-limit"
import Blacklight from "blacklight-frontend"
import { initRangeSliders } from "./range_slider"

BlacklightRangeLimit.init({ onLoadHandler: Blacklight.onLoad })

// Initialize custom range sliders after blacklight range limit loads
Blacklight.onLoad(initRangeSliders)
