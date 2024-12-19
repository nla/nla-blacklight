# frozen_string_literal: true

module Blacklight
  module Icons
    # This is the remove (x) icon for the facets and constraints.
    # You can override the default svg by setting:
    #   Blacklight::Icons::RemoveComponent.svg = '<svg>your SVG here</svg>'
    class RemoveComponent < Blacklight::Icons::IconComponent
      self.svg = <<~SVG
        <svg width="10px" height="10px" viewBox="0 0 10 10" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
          <title>xmark</title>
          <g id="xmark" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
              <g transform="translate(0.0287, 0.0287)" fill="currentColor" fill-rule="nonzero" id="Path">
                  <path d="M9.64829193,1.69798137 C10.0364907,1.30978261 10.0364907,0.679347826 9.64829193,0.291149068 C9.26009317,-0.0970496894 8.62965839,-0.0970496894 8.24145963,0.291149068 L4.97127329,3.56444099 L1.69798137,0.294254658 C1.30978261,-0.0939440994 0.679347826,-0.0939440994 0.291149068,0.294254658 C-0.0970496894,0.682453416 -0.0970496894,1.3128882 0.291149068,1.70108696 L3.56444099,4.97127329 L0.294254658,8.24456522 C-0.0939440994,8.63276398 -0.0939440994,9.26319876 0.294254658,9.65139752 C0.682453416,10.0395963 1.3128882,10.0395963 1.70108696,9.65139752 L4.97127329,6.37810559 L8.24456522,9.64829193 C8.63276398,10.0364907 9.26319876,10.0364907 9.65139752,9.64829193 C10.0395963,9.26009317 10.0395963,8.62965839 9.65139752,8.24145963 L6.37810559,4.97127329 L9.64829193,1.69798137 Z"></path>
              </g>
          </g>
        </svg>
      SVG
    end
  end
end
