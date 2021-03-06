function [P,S] = readSVG(filename)
  % READSVG  Read <polygon>, <polyline> from a .svg file
  %
  % P = readSVG(filename)
  %
  % Input:
  %   filename  path to .svg file
  % Output:
  %   P  #P list of polylines, if the polygon is closed the the last point will
  %      be the same as the first.
  %   S  #P by 3 list of stroke colors
  %

  xDoc = xmlread(filename);
  
  P = {};
  S = [];

  % Read polygons
  polys = xDoc.getElementsByTagName('polygon');
  for pi = 0:polys.getLength-1
    poly = polys.item(pi);
    Pi = reshape(sscanf(char(poly.getAttribute('points')),'%g,%g '),2,[])';
    % if end isn't exactly begin, make it so
    if any(Pi(1,:) ~= Pi(end,:))
      Pi(end+1,:) = Pi(1,:);
    end
    P{end+1} = Pi;
    hex = char(poly.getAttribute('stroke'));
    if ~isempty(hex)
      S(end+1,:) = hex2rgb(hex(2:end));
    end
  end

  plines = xDoc.getElementsByTagName('polyline');
  for pi = 0:plines.getLength-1
    pline = plines.item(pi);
    P{end+1} = reshape(sscanf(char(pline.getAttribute('points')),'%g,%g '),2,[])';
    hex = char(pline.getAttribute('stroke'));
    if ~isempty(hex)
      S(end+1,:) = hex2rgb(hex(2:end));
    end
  end

end
