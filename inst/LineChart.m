## Copyright (C) 2024 Andreas Bertsatos <abertsatos@biol.uoa.gr>
##
## This file is part of the statistics package for GNU Octave.
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

classdef LineChart

  properties (Access = public)

    labels             = [];
    datasets           = {};
    options            = {};
    chartID            = "lineChart";

  endproperties

  methods (Access = public)

    ## Class object constructor
    function this = LineChart (data, labels, varargin)

      ## Check data and labels
      if (nargin < 2)
        error ("LineChart: too few input arguments.");
      endif
      if (! ismatrix (data) || ! isnumeric (data))
        error ("LineChart: DATA must be a numeric matrix.");
      endif
      if (isempty (data))
        error ("LineChart: DATA cannot be empty.");
      endif
      if (isempty (labels))
        error ("LineChart: LABELS cannot be empty.");
      endif
      if (! isvector (labels))
        error ("LineChart: LABELS must be a vector.");
      endif
      if (ischar (labels))
        labels = cellstr (labels);
      elseif (! isnumeric (labels) && ! iscellstr (labels))
        error (strcat (["LineChart: LABELS must be numeric,"], ...
                       [" cellstring, or character vector."]));
      endif

      ## Force row vectors to column vectors
      if (isvector (data))
        data = data(:);
      endif
      labels = labels(:);

      ## Check for matching sample sizes
      if (numel (labels) != size (data, 1))
        error ("LineChart: LABELS do not match sample size in DATA.");
      endif

      ## Store labels
      this.labels = labels;

      ## Create datasets
      nsets = size (data, 2);
      for i = 1:nsets
        this.datasets{i} = LineData (data(:,i));
      endfor

      ## Handle the optional pair arguments and change
      ## the properties in each dataset as necessary
      if (mod (numel (varargin), 2) != 0)
        error ("LineChart: optional arguments must be in Name,Value pairs.");
      endif
      while (numel (varargin) > 0)
        switch (lower (varargin{1}))
          case "backgroundcolor"
            val = varargin{2};
            pname = "backgroundColor";
            if (! isobject (val))
              this = parseColor (this, pname, val);
            else
              this = parseValue (this, pname, val, "Color", "object");
            endif

          case "bordercapstyle"
            val = varargin{2};
            pname = "borderCapStyle";
            validstr = {"butt", "round", "square"};
            this = parseValue (this, pname, val, validstr, "string");

          case "bordercolor"
            val = varargin{2};
            pname = "borderColor";
            if (! isobject (val))
              this = parseColor (this, pname, val);
            else
              this = parseValue (this, pname, val, "Color", "object");
            endif

          case "borderdash"
            val = varargin{2};
            pname = "borderDash";
            this = parseValue (this, pname, val, [], "vector");

          case "borderdashoffset"
            val = varargin{2};
            pname = "borderDashOffset";
            this = parseValue (this, pname, val, [], "scalar");

          case "borderjoinstyle"
            val = varargin{2};
            pname = "borderJoinStyle";
            validstr = {"bevel", "round", "miter"};
            this = parseValue (this, pname, val, validstr, "string");

          case "borderwidth"
            val = varargin{2};
            pname = "borderWidth";
            this = parseValue (this, pname, val, [], "scalar");

          case "clip"
            val = varargin{2};
            pname = "clip";
            this = parseValue (this, pname, val, [], "scalar");

          case "cubicinterpolationmode"
            val = varargin{2};
            pname = "cubicInterpolationMode";
            validstr = {"default", "monototne"};
            this = parseValue (this, pname, val, validstr, "string");

          case "drawactiveelementsontop"
            val = varargin{2};
            pname = "drawActiveElementsOnTop";
            this = parseValue (this, pname, val, [], "boolean");

          case "fill"
            val = varargin{2};
            pname = "fill";
            validstr = "Fill";
            this = parseValue (this, pname, val, validstr, "object");

          case "hoverbackgroundcolor"
            val = varargin{2};
            pname = "hoverBackgroundColor";
            if (! isobject (val))
              this = parseColor (this, pname, val);
            else
              this = parseValue (this, pname, val, "Color", "object");
            endif

          case "hoverbordercapstyle"
            val = varargin{2};
            pname = "hoverBorderCapStyle";
            validstr = {"butt", "round", "square"};
            this = parseValue (this, pname, val, validstr, "string");

          case "hoverbordercolor"
            val = varargin{2};
            pname = "hoverBorderColor";
            if (! isobject (val))
              this = parseColor (this, pname, val);
            else
              this = parseValue (this, pname, val, "Color", "object");
            endif

          case "hoverborderdash"
            val = varargin{2};
            pname = "hoverBorderDash";
            this = parseValue (this, pname, val, [], "vector");

          case "hoverborderdashoffset"
            val = varargin{2};
            pname = "hoverBorderDashOffset";
            this = parseValue (this, pname, val, [], "scalar");

          case "hoverborderjoinstyle"
            val = varargin{2};
            pname = "hoverBorderJoinStyle";
            validstr = {"bevel", "round", "miter"};
            this = parseValue (this, pname, val, validstr, "string");

          case "hoverborderwidth"
            val = varargin{2};
            pname = "hoverBorderWidth";
            this = parseValue (this, pname, val, [], "scalar");

          case "indexaxis"
            val = varargin{2};
            pname = "indexAxis";
            validstr = {"x", "y"};
            this = parseValue (this, pname, val, validstr, "string");

          case "label"
            val = varargin{2};
            pname = "label";
            this = parseValue (this, pname, val, val, "string");

          case "order"
            val = varargin{2};
            pname = "order";
            this = parseValue (this, pname, val, [], "scalar");

          case "pointbackgroundcolor"
            val = varargin{2};
            pname = "pointBackgroundColor";
            if (! isobject (val))
              this = parseColor (this, pname, val);
            else
              this = parseValue (this, pname, val, "Color", "object");
            endif

          case "pointbordercolor"
            val = varargin{2};
            pname = "pointBorderColor";
            if (! isobject (val))
              this = parseColor (this, pname, val);
            else
              this = parseValue (this, pname, val, "Color", "object");
            endif

          case "pointborderwidth"
            val = varargin{2};
            pname = "pointBorderWidth";
            this = parseValue (this, pname, val, [], "scalar");

          case "pointhitradius"
            val = varargin{2};
            pname = "pointHitRadius";
            this = parseValue (this, pname, val, [], "scalar");

          case "pointhoverbackgroundcolor"
            val = varargin{2};
            pname = "pointHoverBackgroundColor";
            if (! isobject (val))
              this = parseColor (this, pname, val);
            else
              this = parseValue (this, pname, val, "Color", "object");
            endif

          case "pointhoverbordercolor"
            val = varargin{2};
            pname = "pointHoverBorderColor";
            if (! isobject (val))
              this = parseColor (this, pname, val);
            else
              this = parseValue (this, pname, val, "Color", "object");
            endif

          case "pointhoverborderwidth"
            val = varargin{2};
            pname = "pointHoverBorderWidth";
            this = parseValue (this, pname, val, [], "scalar");

          case "pointhoverradius"
            val = varargin{2};
            pname = "pointHoverRadius";
            this = parseValue (this, pname, val, [], "scalar");

          case "pointradius"
            val = varargin{2};
            pname = "pointRadius";
            this = parseValue (this, pname, val, [], "scalar");

          case "pointrotation"
            val = varargin{2};
            pname = "pointRotation";
            this = parseValue (this, pname, val, [], "scalar");

          case "pointstyle"
            val = varargin{2};
            this = parseStyle (this, val);

          case "showline"
            val = varargin{2};
            pname = "showLine";
            this = parseValue (this, pname, val, [], "boolean");

          case "spangaps"
            val = varargin{2};
            pname = "spanGaps";
            this = parseValue (this, pname, val, [], "boolean");

          case "stack"
            val = varargin{2};
            pname = "stack";
            this = parseValue (this, pname, val, val, "boolstring");

          case "stepped"
            val = varargin{2};
            pname = "stepped";
            validstr = {"before", "after", "middle"};
            this = parseValue (this, pname, val, validstr, "boolstring");

          case "tension"
            val = varargin{2};
            pname = "tension";
            this = parseValue (this, pname, val, [], "scalar");

          case "chartid"
            val = varargin{2};
            if (! ischar (val))
              error ("LineChart: 'ChartID' must be a character vector.");
            endif
            this.chartID = val;

        endswitch
        varargin([1:2]) = [];
      endwhile

    endfunction

    ## Export to json string
    function json = jsonstring (this)

      ## Initialize json string
      json = "{\n  type: 'line',\n  data: {\n";

      ## Add labels
      if (isnumeric (this.labels))
        labels = sprintf ("%g, ", this.labels);
      else
        labels = sprintf ("'%s', ", this.labels{:});
      endif
      labels(end) = [];
      labels(end) = "]";
      json = [json, "    labels: [", labels, ",\n"];

      ## Add datasets
      json = [json, "    datasets: ["];
      for i = 1:numel (this.datasets)
        dataset = jsonstring (this.datasets{i});
        json = [json, dataset, ","];
      endfor

      ## Close data
      json(end) = "]";
      json = [json, "\n  },\n"];

      ## Add options and close Chart configuration json string
      options = "  options: {}\n";
      json = [json, options, "}"];

    endfunction

    ## Export to html string
    function html = htmlstring (this)

      ## Initialize html string
      tmp1 = "<!DOCTYPE html>\n<html>\n";
      tmp2 = "  <script src=""https://cdn.jsdelivr.net/npm/chart.js"">";
      tmp3 = "  </script>\n  <body>\n    <div>\n";
      tmp4 = "    <canvas id=""%s"" style=""width:100%%;max-width:1000px"">";
      ## Add chart ID
      tmp4 = sprintf (tmp4, this.chartID);
      tmp5 = "</canvas>\n    </div>\n  </body>\n</html>\n";
      tmp6 = "<script>\n";
      tmp7 = sprintf ("new Chart('%s', ", this.chartID);
      ## Get Chart configuration json string
      json = jsonstring (this);
      ## Close html string
      tmp8 = ");\n</script>";
      html = [tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, json, tmp8];

    endfunction

    ## Save to html file
    function htmlsave (this, filename)

      ## Write html string to file
      fid = fopen (filename, "w");
      fprintf (fid, "%s", htmlstring (this));
      fclose (fid);

    endfunction

    ## Serve Chart online
    function webserve (this, port = 8080)

      ## Check for valid port number
      if (! (isnumeric (val) && isscalar (val) &&
             fix (val) == val && val > 0 && val <= 65535))
        error (strcat (["LineChart.webserve: 'port' must be a scalar"], ...
                       [" integer value assigning a valid port."]));
      endif

      ## Build html page and serve it on assigned port
      html = htmlstring (this);
      webserve (html, port);

    endfunction

    ## Close web service
    function webstop (this)
        webserve (0);
    endfunction

  endmethods

endclassdef

## Test input validation
%!error <LineChart: too few input arguments.> LineChart (1)
%!error <LineChart: DATA must be a numeric matrix.> LineChart ({1}, "A")
%!error <LineChart: DATA must be a numeric matrix.> LineChart ("1", "A")
%!error <LineChart: DATA cannot be empty.> LineChart ([], "A")
%!error <LineChart: LABELS cannot be empty.> LineChart (1, [])
%!error <LineChart: LABELS must be a vector.> LineChart (ones (2), ones (2))
%!error <LineChart: LABELS must be numeric, cellstring, or character vector.> ...
%! LineChart (ones (2), {1, 2})
%!error <LineChart: LABELS do not match sample size in DATA.> ...
%! LineChart (ones (2), "A")
%!error <LineChart: optional arguments must be in Name,Value pairs.> ...
%! LineChart (1, "A", "backgroundColor")
