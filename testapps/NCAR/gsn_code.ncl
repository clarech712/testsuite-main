;
;      $Id: gsn_code.ncl,v 1.13 1999/04/29 21:58:43 haley Exp $
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                      ;
;                Copyright (C)  1998                                   ;
;        University Corporation for Atmospheric Research               ;
;                All Rights Reserved                                   ;
;                                                                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;  File:       gsn_code.ncl
;;
;;  Author:     Mary Haley
;;          National Center for Atmospheric Research
;;          PO 3000, Boulder, Colorado
;;
;;  Date:       Sat Apr 11 12:42:53 MST 1998
;;
;;  Description: This script defines all of the basic plotting and
;;               miscellaneous functions and procedures used in the 
;;               examples in the "Getting started using NCL" documention.
;;	             The URL for this document is:
;;
;;                   http://ngwww.ucar.edu/ngdoc/ng/ug/ncl/gsun/
;;
;;               To use the functions and procedures in this script,
;;               you must have the line:
;;
;;                   load "gsn_code.ncl"
;; 
;;               at the top of your NCL script, before the begin statement.
;;

;***********************************************************************;
; For every function and procedure defined in this script, undefine it  ;
; with a call to "undef" so it doesn't clash with other functions and   ;
; procedures with the same name.                                        ;
;***********************************************************************;

undef("gsnp_turn_off_tickmarks")
undef("gsn_open_ps")
undef("gsn_open_x11")
undef("gsn_open_ncgm")
undef("gsn_open_wks")
undef("gsn_define_colormap")
undef("gsn_retrieve_colormap")
undef("gsn_panel")
undef("gsn_contour")
undef("gsn_contour_map")
undef("gsn_labelbar_ndc")
undef("gsn_map")
undef("gsn_polygon")
undef("gsn_polygon_ndc")
undef("gsn_polyline")
undef("gsn_polyline_ndc")
undef("gsn_polymarker")
undef("gsn_polymarker_ndc")
undef("gsn_streamline")
undef("gsn_streamline_map")
undef("gsn_text")
undef("gsn_text_ndc")
undef("gsn_vector")
undef("gsn_vector_contour")
undef("gsn_vector_contour_map")
undef("gsn_vector_map")
undef("gsn_vector_scalar")
undef("gsn_vector_scalar_map")
undef("gsn_xy")


procedure gsnp_turn_off_tickmarks(res:logical)
begin
  res@tmXBBorderOn = False 
  res@tmXBOn       = False
  res@tmXTBorderOn = False
  res@tmXTOn       = False
  res@tmYLBorderOn = False
  res@tmYLOn       = False
  res@tmYRBorderOn = False
  res@tmYROn       = False
end

;***********************************************************************;
; Function : gsn_open_ncgm                                              ;
;               name : name of output cgm file                          ;
;                                                                       ;
; This function opens an NCGM output file called "<name>.ncgm" and      ;
; returns the workstation id. If "name" is an empty string, then the    ;
; NCGM is given its default name "gmeta".                               ;
;***********************************************************************;

function gsn_open_ncgm(name[1]:string)
local ncgm, res_file
begin
    if(isatt(name,"res_file"))
      res_file = name@res_file
    else
      res_file = "gsnapp"
    end if

    if(isatt(name,"wkColorMap"))
      ncgm = create res_file ncgmWorkstationClass defaultapp 
        "wkMetaName" : name
        "wkColorMap" : name@wkColorMap
      end create
    else
      ncgm = create res_file ncgmWorkstationClass defaultapp 
        "wkMetaName" : name
      end create
    end if


    return(ncgm)
end

;***********************************************************************;
; Function : gsn_open_x11                                               ;
;               name : name of X11 window                               ;
;                                                                       ;
; This function opens an X11 output window and returns the workstation  ;
; id.                                                                   ;
;***********************************************************************;

function gsn_open_x11(name[1]:string)
local window
begin
    if(isatt(name,"wkColorMap"))
      window = create name + "_x11" xWorkstationClass defaultapp
        "wkPause" : True
        "wkColorMap" : name@wkColorMap
      end create
    else
      window = create name + "_x11" xWorkstationClass defaultapp
        "wkPause" : True
      end create
    end if
    return(window)
end

;***********************************************************************;
; Function : gsn_open_ps                                                ;
;               name : name of PostScript file                          ;
;                                                                       ;
; This function opens a PostScript file called "<name>.ps" and returns  ;
; the workstation id. If "name" is an empty string, then the PostScript ;
; file is called "gmeta.ps".                                            ;
;***********************************************************************;

function gsn_open_ps(type:string,name[1]:string)
local ps, res_file
begin
    lower_x  =  36
    lower_y  = 126
    upper_x  = 576
    upper_y  = 666
    cmap     = "default"
    orient   = "portrait"
    resltn   = 1800
    res_file = "gsnapp"
    
    if(isatt(name,"res_file"))
      res_file = name@res_file
    end if

    if(isatt(type,"wkPSResolution"))
      resltn = type@wkPSResolution
    end if

    if(isatt(type,"wkOrientation"))
      orient = type@wkOrientation
    end if

    if(isatt(type,"wkDeviceLowerX"))
      lower_x = type@wkDeviceLowerX
    end if

    if(isatt(type,"wkDeviceLowerY"))
      lower_y = type@wkDeviceLowerY
    end if

    if(isatt(type,"wkDeviceUpperX"))
      upper_x = type@wkDeviceUpperX
    end if

    if(isatt(type,"wkDeviceUpperY"))
      upper_y = type@wkDeviceUpperY
    end if

    if(isatt(type,"wkColorMap"))
      delete(cmap)
      cmap = type@wkColorMap
    end if

    ps = create res_file psWorkstationClass defaultapp
      "wkColorMap"     : cmap
      "wkOrientation"  : orient
      "wkPSResolution" : resltn
      "wkPSFileName"   : name
      "wkPSFormat"     : type
      "wkDeviceLowerX" : lower_x
      "wkDeviceLowerY" : lower_y
      "wkDeviceUpperX" : upper_x
      "wkDeviceUpperY" : upper_y
    end create

    return(ps)
end

;***********************************************************************;
; Function : gsn_open_wks                                               ;
;               type : type of workstation to open                      ;
;               name : name of workstation                              ;
;                                                                       ;
; This function opens either an X11 window, an NCGM file, or a          ;
; PostScript file depending on "type", which can be "x11", "ncgm", or   ;
; "ps". If "type" is a PS file or an NCGM, then it will be named        ;
; <name>.ps or <name>.ncgm respectively. This function also looks for a ;
; resource file called "name.res". If it exists, then it loads the      ;
; resources defined in that file. This function returns the workstation ;
; id.                                                                   ;
;***********************************************************************;

function gsn_open_wks(type[1]:string,name[1]:string)
local i, wks, appusrdir, name_char, not_found, res_file, res_dir
begin
    res_dir = "./"          ; Default resource directory.
    res_file = "gsnapp"     ; Default resource file name.

    if(name.ne."") then
      name_char = stringtochar(name)
      name_len  = dimsizes(name_char)-1
      i = name_len-1      ; Start checking if a directory pathname
      not_found = True    ; was specified for the resource file.
      do while(not_found.and.i.ge.0)
        if(name_char(i).eq."/")
          res_dir  = chartostring(name_char(0:i))
          not_found = False
        end if
        i = i - 1
      end do

      res_file = chartostring(name_char(i+1:name_len-1))

      if(isatt(name,"appUsrDir").and.not_found)
        res_dir = name@appUsrDir   ; No directory specified.
      end if
    end if

    if(isatt(type,"wkMetaName"))
        ncgm_file = type@wkMetaName
    else
        ncgm_file = res_file + ".ncgm"
    end if
    ncgm_file@res_file = res_file

    if(isatt(type,"wkPSFileName"))
        ps_file = type@wkPSFileName
    else
        ps_file = res_file + "." + type
    end if

    ps_file@res_file = res_file

    x_file = res_file

;
; Check if color map being set.  The PostScript color map will get 
; passed automatically through "type".
;
    if(isatt(type,"wkColorMap"))
      ncgm_file@wkColorMap = type@wkColorMap
      x_file@wkColorMap    = type@wkColorMap
    end if

    appid = create res_file appClass defaultapp
        "appDefaultParent" : True
        "appUsrDir"        : res_dir
    end create

    if(type.eq."x11".or.type.eq."X11") then
        wks = gsn_open_x11(x_file)
    else
        if(type.eq."ps".or.type.eq."eps".or.type.eq."epsi".or.\
           type.eq."PS".or.type.eq."EPS".or.type.eq."EPSI") then
            wks = gsn_open_ps(type,ps_file)
        else
            if(type.eq."ncgm".or.type.eq."NCGM") then
                wks = gsn_open_ncgm(ncgm_file)
            else
                 print("Error: gsn_open_wks: "+ type + " is an illegal workstation type.")
                 exit
            end if
        end if
    end if
    wks@name = res_file
    wks@app = appid 
    return(wks)
end

;***********************************************************************;
; Procedure : gsn_panel                                                 ;
;                 wks: workstation object                               ;
;               plot : array of plots to put on one page.               ;
;               dims : a 2-D array indicating number of rows and columns;
;             resources: optional resources                             ;
;                                                                       ;
; This procedure takes the array of plots and draws them all on one     ;
; workstation in the configuration specified by dims.                   ;
;                                                                       ;
; For example, if you have six plots and dims is (/2,3/), then the six  ;
; plots will be drawn in 2 rows and 3 columns.                          ;
;                                                                       ;
;***********************************************************************;
procedure gsn_panel(wks:graphic,plot[*]:graphic,dims[2]:float,\
                    resources:logical )
local rows, cols, xrows, xcols, top, bottom, left, right, \
vpx, vpy, vpwidth, vpheight, bb, plot_width, plot_height, \
xwsp_perc, ywsp_perc, xwsp, ywsp, dx, dy, total_width, total_height, \
col_scale, row_scale, scale, xpos, ypos, xsp, ysp, \
new_plot_height, new_plot_width, new_total_height, new_total_width, \
i, j, old_vpx, old_vpy, old_vpwidth, old_vpheight, callframe
begin
    rows = floattointeger(dims(0))
    cols = floattointeger(dims(1))
    xrows = dims(0)
    xcols = dims(1)
    xwsp_perc = 1.0   ; White space is 1% of total length of plot.
    ywsp_perc = 1.0   ; This can be changed with an attribute.
    x_lft = 0.0
    y_top = 1.0
    x_rgt = 1.0
    y_bot = 0.0
    callframe = True

	if(resources)
      if(isatt(resources,"gsnFrame").and..not.resources@gsnFrame)
          callframe = False
      end if
      if(isatt(resources,"gsnPanelXWhiteSpacePercent"))
        xwsp_perc = resources@gsnPanelXWhiteSpacePercent
        if(xwsp_perc.lt.0.or.xwsp_perc.ge.100.)
          print("Warning: gsn_panel: attribute gsnPanelXWhiteSpacePercent must be >= 0 and < 100.")
          print("Defaulting to 1.")
          xwsp_perc = 1.
        end if
      end if
      if(isatt(resources,"gsnPanelYWhiteSpacePercent"))
        ywsp_perc = resources@gsnPanelYWhiteSpacePercent
        if(ywsp_perc.lt.0.or.ywsp_perc.ge.100.)
          print("Warning: gsn_panel: attribute gsnPanelYWhiteSpacePercent must be >= 0 and < 100.")
          print("Defaulting to 1.")
          ywsp_perc = 1.
        end if
      end if

      if(isatt(resources,"gsnPanelLeft"))
        x_lft = resources@gsnPanelLeft
        if(x_lft.lt.0..or.x_lft.ge.1.)
          print("Warning: gsn_panel: attribute gsnPanelLeft must be >= 0.0 and < 1.0")
          print("Defaulting to 0.")
          x_lft = 0.0
        end if
      end if

      if(isatt(resources,"gsnPanelRight"))
        x_rgt = resources@gsnPanelRight
        if(x_rgt.le.0..or.x_rgt.gt.1.)
          print("Warning: gsn_panel: attribute gsnPanelRight must be > 0.0 and <= 1.0")
          print("Defaulting to 1.")
          x_rgt = 1.0
        end if
      end if

      if(isatt(resources,"gsnPanelTop"))
        y_top = resources@gsnPanelTop
        if(y_top.le.0..or.y_top.gt.1.)
          print("Warning: gsn_panel: attribute gsnPanelTop must be > 0.0 and <= 1.0")
          print("Defaulting to 1.")
          y_top = 1.0
        end if
      end if

      if(isatt(resources,"gsnPanelBottom"))
        y_bot = resources@gsnPanelBottom
        if(y_bot.lt.0..or.y_bot.ge.1.)
          print("Warning: gsn_panel: attribute gsnPanelBottom must be >= 0.0 and < 1.0")
          print("Defaulting to 0.")
          y_bot = 0.0
        end if
      end if

      if(x_rgt.le.x_lft)
        print("Error: gsn_panel: attribute gsnPanelRight ("+x_rgt+") must be greater")
        print("than gsnPanelLeft ("+x_lft+").")
        exit
      end if

      if(y_top.le.y_bot)
        print("Error: gsn_panel: attribute gsnPanelTop ("+y_top+") must be greater")
        print("than gsnPanelBottom ("+y_bot+").")
        exit
      end if

    end if

;
; Make sure we have enough panels to fit all of the plots.
;
    nplots  = dimsizes(plot)      ; Total number of plots.
    npanels = rows*cols           ; Total number of panels.
    if(nplots.gt.npanels)
      print("Warning: gsn_panel: you have more plots than you have panels.")
      print("Only " + npanels + " plots will be drawn.")
    end if

    getvalues plot(0)
      "vpXF"      : vpx       ; Get original view port coordinates.
      "vpYF"      : vpy
      "vpWidthF"  : vpwidth
      "vpHeightF" : vpheight
    end getvalues

    bb = NhlGetBB(plot(0))   ; Get bounding box of plot with
    top    = bb(0)           ; all of its annotations.
    bottom = bb(1)
    left   = bb(2)
    right  = bb(3)

;
; plot_width  : total width of plot with all of its annotations
; total_width : plot_width plus white space on both sides
;
    plot_width  = right - left     ; Calculate total width of plot.
    plot_height = top - bottom     ; Calculate total height of plot.

    xwsp = xwsp_perc/100. * plot_width  ; White space is a percentage of total
    ywsp = ywsp_perc/100. * plot_height ; width and height.

    total_width  = 2.*xwsp + plot_width   ; Calculate total width and height
    total_height = 2.*ywsp + plot_height  ; with white space added.
;
; We want:
;
;   ncols * scale * total_width  <= x_rgt - x_lft (the viewport width)
;   nrows * scale * total_height <= y_top - y_bot (the viewport height)
;
; By taking the minimum of these two, we get the scale
; factor that we need to fit all plots on a page.
;
    xrange = x_rgt - x_lft
    yrange = y_top - y_bot

    col_scale = min((/xrange/(xcols*total_width), xrange/))
    row_scale = min((/yrange/(xrows*total_height),yrange/))
    scale = min((/col_scale,row_scale/))

    new_plot_width  = scale*plot_width    ; Calculate new width
    new_plot_height = scale*plot_height   ; and height.

    xwsp = xwsp_perc/100. * new_plot_width   ; Calculate new white space.
    ywsp = ywsp_perc/100. * new_plot_height

    new_total_width  = 2.*xwsp + new_plot_width  ; Calculate new total width
    new_total_height = 2.*ywsp + new_plot_height ; and height w/white space.

    xsp = xrange - new_total_width*cols   ; Calculate total amt of white space
    ysp = yrange - new_total_height*rows  ; left in both X and Y directions.

    dx = scale * (vpx - left) ; Calculate distance from plot's left position
                              ; to its leftmost annotation
    dy = scale * (top - vpy) ; Calculate distance from plot's top position
                             ; to its topmost annotation.

    xpos = x_lft + xwsp + dx +(xsp/2.+new_total_width*ispan(0,cols-1,1))
    ypos = y_top - ywsp - dy -(ysp/2.+new_total_height*ispan(0,rows-1,1))

;
; Loop through each plot and draw it in the new scaled-down size.
;
    do i = 0,rows-1
      do j = 0,cols-1
        if(i*cols+j .lt. dimsizes(plot))
          if(.not.ismissing(plot(i*cols+j)))
            getvalues plot(i*cols+j)
              "vpXF"      : old_vpx
              "vpYF"      : old_vpy
              "vpWidthF"  : old_vpwidth
              "vpHeightF" : old_vpheight
            end getvalues

            setvalues plot(i*cols+j)
              "vpXF"      : xpos(j)
              "vpYF"      : ypos(i)
              "vpWidthF"  : scale*old_vpwidth 
              "vpHeightF" : scale*old_vpheight
            end setvalues

            draw(plot(i*cols+j))  ; Draw the scaled down plot.

            setvalues plot(i*cols+j)
              "vpXF"      : old_vpx
              "vpYF"      : old_vpy
              "vpWidthF"  : old_vpwidth
              "vpHeightF" : old_vpheight
            end setvalues
          end if
        end if
      end do  ; end of columns
    end do    ; end of rows

    if(callframe)
        frame(wks)   ; Advance the frame.
    end if
end

;***********************************************************************;
; Procedure : gsn_define_colormap                                       ;
;                   wks: workstation object                             ;
;                  cmap: Colormap (n x 3 array)                         ;
;                                                                       ;
; This procedure defines a color map for workstation "wks" (the         ;
; variable returned from a previous call to "gsn_open_wks") using float ;
; RGB values.                                                           ;
;***********************************************************************;

procedure gsn_define_colormap(wks:graphic, cmap)
begin
  dim_cmap = dimsizes(cmap)
  if((typeof(cmap).eq."float".and.(dimsizes(dim_cmap).ne.2.or.dim_cmap(1).ne.3)).or.\
     (typeof(cmap).eq."string".and.dimsizes(dim_cmap).ne.1))
    print("Warning: gsn_define_colormap: cmap must either be a 2-dimensional float array")
    print("dimensioned n x 3 or a 1-dimensional string array.")
  else
    setvalues wks
        "wkColorMap" : cmap
    end setvalues
  end if
end

;***********************************************************************;
; Function : gsn_retrieve_colormap                                      ;
;                   wks: workstation object                             ;
;                                                                       ;
; This function retrieves the current color map in use for workstation  ;
; "wks". "wks is the workstation id returned from a call to             ;
; gsn_open_wks.  The return variable will be an n x 3 array, where n is ;
; the number of colors, and the 3 represents the R, G, and B values.    ;
;***********************************************************************;

function gsn_retrieve_colormap(wks:graphic)
begin
    getvalues wks
        "wkColorMap" : cmap
    end getvalues

    return(cmap)
end

;***********************************************************************;
; Function : gsn_contour                                                ;
;                   wks: workstation object                             ;
;                  data: 2-dimensional data                             ;
;             resources: optional resources                             ;
;                                                                       ;
; This function creates and draws a contour plot to the workstation     ;
; "wks" (the variable returned from a previous call to "gsn_open_wks"). ;
; "data" is the 2-dimensional data to be contoured, and "resources" is  ;
; an optional list of resources. The id of the contour plot is returned.;
;***********************************************************************;

function gsn_contour(wks:graphic, data[*][*]:numeric, resources:logical )
local i, attnames, data_object, plot_object, res, sf_res_index, \
datares, cnres, trres, cn_res_index, tr_res_index, calldraw, callframe, \
force_xaxis_linear, force_yaxis_linear, force_xaxis_log, force_yaxis_log, \
trxmin, trxmax, trymin, trymax, res2
begin
    calldraw = True
    callframe = True
    scale     = False
    shape     = False
    cnres     = False
    trres     = False
    res2      = resources

    force_xaxis_linear = False
    force_yaxis_linear = False
    force_xaxis_log    = False
    force_yaxis_log    = False

; Create the data object.

    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    data_object = create wksname + "_data" scalarFieldClass noparent
        "sfDataArray" : data
    end create

; Check for a missing value.

    if(isatt(data,"_FillValue")) then
        setvalues data_object
            "sfMissingValueV" :data@_FillValue
        end setvalues
    end if

; Create plot object.

    plot_object = create wksname + "_contour" contourPlotClass wks
        "cnScalarFieldData" : data_object
    end create

; Check for existence of data@long_name and use it in a title it
; it exists.

    if(isatt(data,"long_name")) then
        setvalues plot_object
            "tiMainString" : data@long_name
        end setvalues
    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False
            end if
            delete(res2@gsnDraw)
        end if

        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

; Check if the plot should be reshaped or scaled.

        if(isatt(res2,"gsnScale"))
            if(res2@gsnScale)
                scale = True
            end if
            delete(res2@gsnScale)
        end if

        if(isatt(res2,"gsnShape"))
            if(res2@gsnShape)
                shape = True
                scale = True
            end if
            delete(res2@gsnShape)
        end if

;
; Check if a linear or log axis is wanted (this should only be used if
; irregularly-spaced data is used for the X or Y axis (i.e. if sfXArray
; or sfYArray are set).
;
        if(isatt(res2,"gsnXAxisIrregular2Linear"))
          if(res2@gsnXAxisIrregular2Linear)
            force_xaxis_linear = True
          end if
          delete(res2@gsnXAxisIrregular2Linear)
        end if

        if(isatt(res2,"gsnYAxisIrregular2Linear"))
          if(res2@gsnYAxisIrregular2Linear)
            force_yaxis_linear = True
          end if
          delete(res2@gsnYAxisIrregular2Linear)
        end if

        if(isatt(res2,"gsnXAxisIrregular2Log"))
          if(res2@gsnXAxisIrregular2Log)
            force_xaxis_log = True
          end if
          delete(res2@gsnXAxisIrregular2Log)
        end if

        if(isatt(res2,"gsnYAxisIrregular2Log"))
          if(res2@gsnYAxisIrregular2Log)
            force_yaxis_log = True
          end if
          delete(res2@gsnYAxisIrregular2Log)
        end if

        if(force_yaxis_log.and.force_yaxis_linear)
         print("Error: gsn_contour: you cannot set both gsnYAxisIrregular2Log")
         print("and gsnYAxisIrregular2Linear to True.")
         exit
       end if

        if(force_xaxis_log.and.force_xaxis_linear)
         print("Error: gsn_contour: you cannot set both gsnXAxisIrregular2Log")
         print("and gsnXAxisIrregular2Linear to True.")
         exit
       end if

; Check if turning tickmarks off.

        if(isatt(res2,"gsnTickMarksOn"))
            if(.not.res2@gsnTickMarksOn)
              gsnp_turn_off_tickmarks(res2)
            end if
            delete(res2@gsnTickMarksOn)
        end if

    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
; Get list of resources.
        attnames = getvaratts(res2)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

;***********************************************************************;
; Check to see if any data resources were set (these are resources that ;
; start with the two-letter index "sf") or if any contour resources were;
; set.  We assume that anything that doesn't start with an "sf" is a    ;
; contour or contour-related resource.                                  ;
;***********************************************************************;

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."sf")
                setvalues data_object
                    attnames : res2@$attnames$
                end setvalues
            else
                setvalues plot_object
                    attnames : res2@$attnames$
                end setvalues
            end if
            if(force_xaxis_linear.or.force_xaxis_log.or. \
               force_yaxis_linear.or.force_yaxis_log)
              if(chartostring(res(0:1)).eq."tr")
                trres = True
                trres@$attnames$ = res2@$attnames$
              end if
            end if
      else
            cn_res_index = ind(chartostring(res(:,0:1)).ne."sf")
            sf_res_index = ind(chartostring(res(:,0:1)).eq."sf")
            if(.not.all(ismissing(sf_res_index)))
                datares = True
                do i = 0,dimsizes(sf_res_index)-1
                    datares@$attnames(sf_res_index(i))$ = res2@$attnames(sf_res_index(i))$
                end do
                attsetvalues(data_object,datares)
            end if
            if(.not.all(ismissing(cn_res_index)))
                cnres = True
                do i = 0,dimsizes(cn_res_index)-1
                    cnres@$attnames(cn_res_index(i))$ = res2@$attnames(cn_res_index(i))$
                end do
                attsetvalues(plot_object,cnres)
            end if
            if(force_xaxis_linear.or.force_xaxis_log.or. \
               force_yaxis_linear.or.force_yaxis_log)
              tr_res_index = ind(chartostring(res(:,0:1)).eq."tr")
              if(.not.all(ismissing(tr_res_index)))
                  trres = True
                  do i = 0,dimsizes(tr_res_index)-1
                    trres@$attnames(tr_res_index(i))$ = res2@$attnames(tr_res_index(i))$
                  end do
              end if
            end if
        end if
    end if

;
; If gsnShape was set to True, then resize the X or Y axis so that
; the scales are proportionally correct.
; 
    if(shape)
        getvalues plot_object
          "vpXF"      : xf
          "vpYF"      : yf
          "vpWidthF"  : width
          "vpHeightF" : height
          "trXMinF"   : trxmin
          "trXMaxF"   : trxmax
          "trYMinF"   : trymin
          "trYMaxF"   : trymax
        end getvalues

        xrange = trxmax - trxmin
        yrange = trymax - trymin

        if(xrange.lt.yrange)
          new_width  = width * (xrange/yrange)
          new_height = height
          new_xf     = xf + 0.5*(width-new_width)
          new_yf     = yf
        else
          new_height = height * (yrange/xrange)
          new_width  = width
          new_yf     = yf - 0.5*(height-new_height)
          new_xf     = xf
        end if

        setvalues plot_object
          "vpXF"      : new_xf
          "vpYF"      : new_yf
          "vpWidthF"  : new_width
          "vpHeightF" : new_height
        end setvalues
    end if

;
; If gsnScale was set to True, then make sure the X and Y axis labels
; and tick marks are the same size.
; 
    if(scale)
        getvalues plot_object
          "tiXAxisFontHeightF"   : xfontf
          "tiYAxisFontHeightF"   : yfontf
          "tmXBLabelFontHeightF" : xbfontf
          "tmXBMajorLengthF"     : xlengthf
          "tmXBMinorLengthF"     : xmlengthf
          "tmYLLabelFontHeightF" : ylfontf
          "tmYLMajorLengthF"     : ylengthf
          "tmYLMinorLengthF"     : ymlengthf
        end getvalues

        setvalues plot_object
          "tiXAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tiYAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tmXBLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmXBMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmXBMinorLengthF"     : (ymlengthf+xmlengthf)/2.
          "tmYLLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmYLMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmYLMinorLengthF"     : (ymlengthf+xmlengthf)/2.
        end setvalues
    end if

; Check if we need to force the X or Y axis to be linear or log.
; If so, then we have to overlay it on a LogLin Plot.

     if(force_xaxis_linear.or.force_xaxis_log.or. \
        force_yaxis_linear.or.force_yaxis_log)

       overlay_plot_object = plot_object
       delete(plot_object)

       getvalues overlay_plot_object
         "trXMinF"    : trxmin
         "trXMaxF"    : trxmax
         "trYMinF"    : trymin
         "trYMaxF"    : trymax
       end getvalues

      plot_object = create wksname + "_loglin" logLinPlotClass wks
        "trXLog"  : force_xaxis_log
        "trYLog"  : force_yaxis_log
        "trXMinF" : trxmin
        "trXMaxF" : trxmax
        "trYMinF" : trymin
        "trYMaxF" : trymax
      end create
      if(trres)
        attsetvalues(plot_object,trres)
      end if

      overlay(plot_object,overlay_plot_object)
      plot_object@contour = overlay_plot_object
    end if

    if(calldraw)
        draw(plot_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object and data object (as attribute of plot object).

    plot_object@data = data_object
    return(plot_object)
end

;***********************************************************************;
; Function : gsn_contour_map                                            ;
;                   wks: workstation object                             ;
;                  data: 2-dimensional data                             ;
;               resources: optional resources                           ;
;                                                                       ;
; This function creates and draws a contour plot over a map plot to the ;
; workstation "wks" (the variable returned from a previous call to      ;
; "gsn_open_wks").  "data" is the 2-dimensional data to be contoured,   ;
; and "resources" is an optional list of resources. The id of the map   ;
; plot is returned.                                                     ;
;***********************************************************************;

function gsn_contour_map(wks:graphic,data[*][*]:numeric,\
                         resources:logical)
local i, attnames, data_object, contour_object, res, sf_res_index, \
cn_res_index, mp_res_index, map_object, res2
begin
    calldraw  = True
    callframe = True
    scale     = False
    res2      = resources

; Create the data object.

    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    data_object = create wksname + "_data" scalarFieldClass noparent
        "sfDataArray" : data
    end create

; Check for a missing value.

    if(isatt(data,"_FillValue")) then
        setvalues data_object
            "sfMissingValueV" :data@_FillValue
        end setvalues
    end if

; Create plot object.

    contour_object = create wksname + "_contour" contourPlotClass wks
        "cnScalarFieldData" : data_object
    end create

; Check for existence of data@long_name and use it in a title it
; it exists.

    if(isatt(data,"long_name")) then
        setvalues contour_object
            "tiMainString" : data@long_name
        end setvalues
    end if

; Create map object.

    map_object = create wksname + "_map" mapPlotClass wks
    end create

    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False
            end if
            delete(res2@gsnDraw)
        end if
        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

        if(isatt(res2,"gsnScale"))
            if(res2@gsnScale)
                scale = True
            end if
            delete(res2@gsnScale)
        end if

    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
; Get list of resources.

        attnames = getvaratts(res2)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))
        if(dimsizes(dimsizes(res)).eq.1)

;***********************************************************************;
; Check to see if any resources were set. For the data object, resources;
; begin with "sf". For the map object, resources begin with "mp". For   ;
; the contour object, any resource that doesn't start with "mp" or "sf" ;
; is assumed to be a contour or contour-related resource.               ;
;***********************************************************************;

            if(chartostring(res(0:1)).eq."sf")
                setvalues data_object
                    attnames : res2@$attnames$
                end setvalues
            else
                if(chartostring(res(0:1)).eq."mp".or.\
                   chartostring(res(0:1)).eq."vp")
                    setvalues map_object
                        attnames : res2@$attnames$
                    end setvalues
                else 
                    setvalues contour_object
                        attnames : res2@$attnames$
                    end setvalues
                end if
            end if
        else
            sf_res_index = ind(chartostring(res(:,0:1)).eq."sf")
            mp_res_index = ind(chartostring(res(:,0:1)).eq."mp".or.\
                               chartostring(res(:,0:1)).eq."vp")
            cn_res_index = ind(chartostring(res(:,0:1)).ne."mp".and.\
                               chartostring(res(:,0:1)).ne."sf".and.\
                               chartostring(res(:,0:1)).ne."vp")
            if(.not.all(ismissing(sf_res_index)))
                datares = True
                do i = 0,dimsizes(sf_res_index)-1
                    datares@$attnames(sf_res_index(i))$ = res2@$attnames(sf_res_index(i))$
                end do
                attsetvalues(data_object,datares)
            end if
            if(.not.all(ismissing(mp_res_index)))
                mpres = True
                do i = 0,dimsizes(mp_res_index)-1
                    mpres@$attnames(mp_res_index(i))$ = res2@$attnames(mp_res_index(i))$
                end do
                attsetvalues(map_object,mpres)
            end if
            if(.not.all(ismissing(cn_res_index)))
                cnres = True
                do i = 0,dimsizes(cn_res_index)-1
                    cnres@$attnames(cn_res_index(i))$ = res2@$attnames(cn_res_index(i))$
                end do
                attsetvalues(contour_object,cnres)
            end if
        end if
    end if

    overlay(map_object,contour_object)

;
; If gsnScale was set to True, then make sure the X and Y axis labels
; and tick marks are the same size.
; 
    if(scale)
        getvalues contour_object
          "tiXAxisFontHeightF"   : xfontf
          "tiYAxisFontHeightF"   : yfontf
          "tmXBLabelFontHeightF" : xbfontf
          "tmXBMajorLengthF"     : xlengthf
          "tmXBMinorLengthF"     : xmlengthf
          "tmYLLabelFontHeightF" : ylfontf
          "tmYLMajorLengthF"     : ylengthf
          "tmYLMinorLengthF"     : ymlengthf
        end getvalues

        setvalues contour_object
          "tiXAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tiYAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tmXBLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmXBMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmXBMinorLengthF"     : (ymlengthf+xmlengthf)/2.
          "tmYLLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmYLMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmYLMinorLengthF"     : (ymlengthf+xmlengthf)/2.
        end setvalues
    end if

    if(calldraw)
        draw(map_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object and data object (as attribute of plot object).

    map_object@data = data_object
    map_object@contour = contour_object
    return(map_object)
end

;***********************************************************************;
; Procedure : gsn_labelbar_ndc                                          ;
;                   wks: workstation object                             ;
;                  nbox: number of labelbar boxes                       ;
;                labels: labels for boxes                               ;
;                     x: X NDC position of labelbar                     ;
;                     y: Y NDC position of labelbar                     ;
;               resources: optional resources                           ;
;                                                                       ;
; This procedure draws a labelbar on the workstation "wks" (the         ;
; variable returned from a previous call to "gsn_open_wks").            ;
; "resources" is an optional list of resources.                         ;
;***********************************************************************;

procedure gsn_labelbar_ndc(wks:graphic, nbox:integer, labels:string, \
                           x:float,y:float,resources:logical )
local i, lbid, attnames, res, lb_res_index, lbres
begin

    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    lbid = create wksname + "_labelbar" labelBarClass wks
      "vpXF"           : x
      "vpYF"           : y
      "lbBoxCount"     : nbox
      "lbLabelStrings" : labels
    end create

    if((resources).and..not.any(ismissing(getvaratts(resources))))

; Get list of resources.

        attnames = getvaratts(resources)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any labelbar resources were set (these are resources
; that start with the two-letter index "lb").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."lb" .or. chartostring(res(0:1)).eq."vp")
                setvalues lbid
                    attnames : resources@$attnames$
                end setvalues
            end if
        else
            lb_res_index = ind(chartostring(res(:,0:1)).eq."lb".or.chartostring(res(:,0:1)).eq."vp")
            if(.not.all(ismissing(lb_res_index)))
                lbres = True
                do i = 0,dimsizes(lb_res_index)-1
                    lbres@$attnames(lb_res_index(i))$ = resources@$attnames(lb_res_index(i))$
                end do
                attsetvalues(lbid,lbres)
            end if
        end if
    end if

; Draw labelbar.

    draw(lbid)
    delete(lbid)
end

;***********************************************************************;
; Function : gsn_map                                                    ;
;                      wks: workstation object                          ;
;               projection: Map projection                              ;
;                  resources: optional resources                        ;
;                                                                       ;
; This function creates and draws a map plot to the workstation "wks"   ;
; (the variable returned from a previous call to "gsn_open_wks").       ;
; "projection" is one of the ten supported map projections, and         ;
; "resources" is an optional list of resources. The id of the map plot  ;
; is returned.                                                          ;
;***********************************************************************;

function gsn_map(wks:graphic, projection:string, resources:logical )
local i, attnames, plot_object, res2
begin
    calldraw = True
    callframe = True
    res2      = resources

; Create plot object.

    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    plot_object = create wksname + "_map" mapPlotClass wks
        "mpProjection" : projection
    end create

; Check to see if any resources were set.

    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False
            end if
            delete(res2@gsnDraw)
        end if
        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
        attsetvalues(plot_object,res2)
    end if

    if(calldraw)
        draw(plot_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object.

    return(plot_object)
end

;***********************************************************************;
; Procedure : gsn_polygon                                               ;
;                   wks: workstation object                             ;
;                plotid: plot object                                    ;
;                     x: 1-dimensional array of x points                ;
;                     y: 1-dimensional array of y points                ;
;               resources: optional resources                           ;
;                                                                       ;
; This procedure draws a filled polygon on the workstation "wks" (the   ;
; variable returned from a previous call to "gsn_open_wks") in the same ;
; data space as the data in "plotid" (returned from a previous call to  ;
; one of the gsn_* plotting functions). "x" and "y" are the x and y     ;
; locations of each point in the polygon, and should be in the same data;
; space as the data from "plotid". "resources" is an optional list of   ;
; resources.                                                            ;
;***********************************************************************;

procedure gsn_polygon(wks:graphic,plotid:graphic,x[*]:numeric,\
                      y[*]:numeric,resources:logical)
local i, gsid, attnames, plot_object, res, gs_res_index, res2
begin

; Retrieve graphic style object.

    getvalues wks 
        "wkDefGraphicStyleId":  gsid
    end getvalues

    if((resources).and..not.any(ismissing(getvaratts(resources))))
; Get list of resources.

        attnames = getvaratts(resources)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any data resources were set (these are resources that
; start with the two-letter index "gs").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."gs")
                setvalues gsid
                    attnames : resources@$attnames$
                end setvalues
            end if
        else
            gs_res_index = ind(chartostring(res(:,0:1)).eq."gs")
            if(.not.all(ismissing(gs_res_index)))
                gsres = True
                do i = 0,dimsizes(gs_res_index)-1
                    gsres@$attnames(gs_res_index(i))$ = resources@$attnames(gs_res_index(i))$
                end do
                attsetvalues(gsid,gsres)
            end if
        end if
    end if

; Draw a polygon.

    if(.not.any(ismissing(x)).and..not.any(ismissing(y)))
      NhlDataPolygon(plotid,gsid,x,y)
    else
      x2 = x(ind(.not.ismissing(x).and..not.ismissing(y)))
      y2 = y(ind(.not.ismissing(x).and..not.ismissing(y)))
      NhlDataPolygon(plotid,gsid,x2,y2)
    end if
end


;***********************************************************************;
; Procedure : gsn_polygon_ndc                                           ;
;                   wks: workstation object                             ;
;                     x: 1-dimensional array of x points                ;
;                     y: 1-dimensional array of y points                ;
;               resources: optional resources                           ;
;                                                                       ;
; This procedure draws a filled polygon on the workstation "wks" (the   ;
; variable returned from a previous call to "gsn_open_wks") in NDC      ;
; space. "x" and "y" are the x and y locations of each point in the     ;
; polygon, and "resources" is an optional list of resources.            ;
;***********************************************************************;

procedure gsn_polygon_ndc(wks:graphic,x[*]:numeric,y[*]:numeric,\
                          resources:logical)
local i, gsid, attnames, plot_object, res, gs_res_index
begin

; Retrieve graphic style object.

    getvalues wks 
        "wkDefGraphicStyleId":  gsid
    end getvalues

;
; Create a LogLinPlot that covers the entire NDC space
; to use as a drawing canvas
;
    canvas = create "canvas" logLinPlotClass wks
      "vpXF"      : 0.0
      "vpYF"      : 1.0
      "vpWidthF"  : 1.0
      "vpHeightF" : 1.0
    end create

    if((resources).and..not.any(ismissing(getvaratts(resources))))
; Get list of resources.

        attnames = getvaratts(resources)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any data resources were set (these are resources that
; start with the two-letter index "gs").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."gs")
                setvalues gsid
                    attnames : resources@$attnames$
                end setvalues
            end if
        else
            gs_res_index = ind(chartostring(res(:,0:1)).eq."gs")
            if(.not.all(ismissing(gs_res_index)))
                gsres = True
                do i = 0,dimsizes(gs_res_index)-1
                    gsres@$attnames(gs_res_index(i))$ = resources@$attnames(gs_res_index(i))$
                end do
                attsetvalues(gsid,gsres)
            end if
        end if
    end if

; Draw a polygon.

    if(.not.any(ismissing(x)).and..not.any(ismissing(y)))
      NhlNDCPolygon(canvas,gsid,x,y)
    else
      x2 = x(ind(.not.ismissing(x).and..not.ismissing(y)))
      y2 = y(ind(.not.ismissing(x).and..not.ismissing(y)))
      NhlNDCPolygon(canvas,gsid,x2,y2)
    end if
end

;***********************************************************************;
; Procedure : gsn_polyline                                              ;
;                   wks: workstation object                             ;
;                plotid: plot object                                    ;
;                     x: 1-dimensional array of x points                ;
;                     y: 1-dimensional array of y points                ;
;               resources: optional resources                           ;
;                                                                       ;
; This procedure draws a polyline on the workstation "wks" (the variable;
; returned from a previous call to "gsn_open_wks") in the same data     ;
; space as the data in "plotid" (returned from a previous call to one of;
; the gsn_* plotting functions). "x" and "y" are the x and y locations  ;
; of each point in the line, and should be in the same data space as the;
; data from "plotid". "resources" is an optional list of resources.     ;
;***********************************************************************;

procedure gsn_polyline(wks:graphic,plotid:graphic,x[*]:numeric,\
                       y[*]:numeric,resources:logical)
local i, gsid, attnames, plot_object, res, gs_res_index
begin

; Retrieve graphic style object.

    getvalues wks 
        "wkDefGraphicStyleId":  gsid
    end getvalues

    if((resources).and..not.any(ismissing(getvaratts(resources))))
; Get list of resources.

        attnames = getvaratts(resources)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any data resources were set (these are resources that
; start with the two-letter index "gs").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."gs")
                setvalues gsid
                    attnames : resources@$attnames$
                end setvalues
            end if
        else
            gs_res_index = ind(chartostring(res(:,0:1)).eq."gs")
            if(.not.all(ismissing(gs_res_index)))
                gsres = True
                do i = 0,dimsizes(gs_res_index)-1
                    gsres@$attnames(gs_res_index(i))$ = resources@$attnames(gs_res_index(i))$
                end do
                attsetvalues(gsid,gsres)
            end if
        end if
    end if

; Draw a polyline.

    if(.not.any(ismissing(x)).and..not.any(ismissing(y)))
      NhlDataPolyline(plotid,gsid,x,y)
    else
;
; Since the data contains missing values, leave gaps where the missing
; values are located.
;
      x2 = new(dimsizes(x),float)
      y2 = new(dimsizes(x),float)
      j = 0
      do i = 0,dimsizes(x)-1
        if(ismissing(x(i)).or.ismissing(y(i)))
          if(j.eq.1)    ; only one value, so draw a marker
            NhlDataPolymarker(plotid,gsid,x2(0),y2(0))
          end if
          if(j.gt.1)    ; multiple values, so draw a line
            NhlDataPolyline(plotid,gsid,x2(0:j-1),y2(0:j-1))
          end if
          j = 0
        else
          x2(j) = x(i)   ; Neither point is missing, so store in
          y2(j) = y(i)   ; separate arrays to draw later.
          j = j + 1
        end if
      end do
      if(j.eq.1)         
        NhlDataPolymarker(plotid,gsid,x2(0),y2(0))
        j = 0
      end if
      if(j.gt.1)         
        NhlDataPolyline(plotid,gsid,x2(0:j-1),y2(0:j-1))
        j = 0
      end if
    end if
end

;***********************************************************************;
; Procedure : gsn_polyline_ndc                                          ;
;                   wks: workstation object                             ;
;                     x: 1-dimensional array of x ndc points            ;
;                     y: 1-dimensional array of y ndc points            ;
;               resources: optional resources                           ;
;                                                                       ;
; This procedure draws a polyline on the workstation "wks" (the variable;
; returned from a previous call to "gsn_open_wks") in NDC space.        ;
; "x" and "y" are the x and y locations of each point in the line.      ;
; "resources" is an optional list of resources.                         ;
;***********************************************************************;

procedure gsn_polyline_ndc(wks:graphic,x[*]:numeric,y[*]:numeric,\
                           resources:logical)
local i, gsid, attnames, plot_object, res, gs_res_index
begin

; Retrieve graphic style object.

    getvalues wks 
        "wkDefGraphicStyleId":  gsid
    end getvalues
;
; Create a LogLinPlot that covers the entire NDC space
; to use as a drawing canvas
;
    canvas = create "canvas" logLinPlotClass wks
      "vpXF"      : 0.0
      "vpYF"      : 1.0
      "vpWidthF"  : 1.0
      "vpHeightF" : 1.0
    end create

    if((resources).and..not.any(ismissing(getvaratts(resources))))
; Get list of resources.

        attnames = getvaratts(resources)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any data resources were set (these are resources that
; start with the two-letter index "gs").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."gs")
                setvalues gsid
                    attnames : resources@$attnames$
                end setvalues
            end if
        else
            gs_res_index = ind(chartostring(res(:,0:1)).eq."gs")
            if(.not.all(ismissing(gs_res_index)))
                gsres = True
                do i = 0,dimsizes(gs_res_index)-1
                    gsres@$attnames(gs_res_index(i))$ = resources@$attnames(gs_res_index(i))$
                end do
                attsetvalues(gsid,gsres)
            end if
        end if
    end if

; Draw a polyline.

    if(.not.any(ismissing(x)).and..not.any(ismissing(y)))
      NhlNDCPolyline(canvas,gsid,x,y)
    else
;
; Since the data contains missing values, leave gaps where the missing
; values are located.
;
      x2 = new(dimsizes(x),float)
      y2 = new(dimsizes(x),float)
      j = 0
      do i = 0,dimsizes(x)-1
        if(ismissing(x(i)).or.ismissing(y(i)))
          if(j.eq.1)    ; only one value, so draw a marker
            NhlNDCPolymarker(canvas,gsid,x2(0),y2(0))
          end if
          if(j.gt.1)    ; multiple values, so draw a line
            NhlNDCPolyline(canvas,gsid,x2(0:j-1),y2(0:j-1))
          end if
          j = 0
        else
          x2(j) = x(i)   ; Neither point is missing, so store in
          y2(j) = y(i)   ; separate arrays to draw later.
          j = j + 1
        end if
      end do
      if(j.eq.1)         
        NhlNDCPolymarker(canvas,gsid,x2(0),y2(0))
        j = 0
      end if
      if(j.gt.1)         
        NhlNDCPolyline(canvas,gsid,x2(0:j-1),y2(0:j-1))
        j = 0
      end if
    end if
end

;***********************************************************************;
; Procedure : gsn_polymarker                                            ;
;                   wks: workstation object                             ;
;                plotid: plot object                                    ;
;                     x: 1-dimensional array of x points                ;
;                     y: 1-dimensional array of y points                ;
;               resources: optional resources                           ;
;                                                                       ;
; This procedure draws polymarkers on the workstation "wks" (the        ;
; variable returned from a previous call to "gsn_open_wks") in the same ;
; data space as the data in "plotid" (returned from a previous call to  ;
; one of the gsn_* plotting functions). "x" and "y" are the x and y     ;
; locations of each marker, and should be in the same data space as the ;
; data from "plotid". "resources" is an optional list of resources.     ;
;***********************************************************************;

procedure gsn_polymarker(wks:graphic,plotid:graphic,x[*]:numeric,\
                         y[*]:numeric,resources:logical)
local i, gsid, attnames, plot_object, res, gs_res_index
begin

; Retrieve graphic style object.

    getvalues wks 
        "wkDefGraphicStyleId":  gsid
    end getvalues

    if((resources).and..not.any(ismissing(getvaratts(resources))))
; Get list of resources.

        attnames = getvaratts(resources)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any data resources were set (these are resources that
; start with the two-letter index "gs").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."gs")
                setvalues gsid
                    attnames : resources@$attnames$
                end setvalues
            end if
        else
            gs_res_index = ind(chartostring(res(:,0:1)).eq."gs")
            if(.not.all(ismissing(gs_res_index)))
                gsres = True
                do i = 0,dimsizes(gs_res_index)-1
                    gsres@$attnames(gs_res_index(i))$ = resources@$attnames(gs_res_index(i))$
                end do
                attsetvalues(gsid,gsres)
            end if
        end if
    end if

; Draw some polymarkers.

    if(.not.any(ismissing(x)).and..not.any(ismissing(y)))
      NhlDataPolymarker(plotid,gsid,x,y)
    else
      x2 = x(ind(.not.ismissing(x).and..not.ismissing(y)))
      y2 = y(ind(.not.ismissing(x).and..not.ismissing(y)))
      NhlDataPolymarker(plotid,gsid,x2,y2)
    end if
end

;***********************************************************************;
; Procedure : gsn_polymarker_ndc                                        ;
;                   wks: workstation object                             ;
;                     x: 1-dimensional array of x points                ;
;                     y: 1-dimensional array of y points                ;
;               resources: optional resources                           ;
;                                                                       ;
; This procedure draws polymarkers on the workstation "wks" (the        ;
; variable returned from a previous call to "gsn_open_wks") in NDC      ;
; space. "x" and "y" are the x and y locations of each marker in NDC    ;
; coordinates. "resources" is an optional list of resources.            ;
;***********************************************************************;

procedure gsn_polymarker_ndc(wks:graphic,x[*]:numeric,y[*]:numeric,\
                         resources:logical)
local i, gsid, attnames, plot_object, res, gs_res_index
begin

; Retrieve graphic style object.

    getvalues wks 
        "wkDefGraphicStyleId":  gsid
    end getvalues

;
; Create a LogLinPlot that covers the entire NDC space
; to use as a drawing canvas
;
    canvas = create "canvas" logLinPlotClass wks
      "vpXF"      : 0.0
      "vpYF"      : 1.0
      "vpWidthF"  : 1.0
      "vpHeightF" : 1.0
    end create

    if((resources).and..not.any(ismissing(getvaratts(resources))))
; Get list of resources.

        attnames = getvaratts(resources)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any data resources were set (these are resources that
; start with the two-letter index "gs").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."gs")
                setvalues gsid
                    attnames : resources@$attnames$
                end setvalues
            end if
        else
            gs_res_index = ind(chartostring(res(:,0:1)).eq."gs")
            if(.not.all(ismissing(gs_res_index)))
                gsres = True
                do i = 0,dimsizes(gs_res_index)-1
                    gsres@$attnames(gs_res_index(i))$ = resources@$attnames(gs_res_index(i))$
                end do
                attsetvalues(gsid,gsres)
            end if
        end if
    end if

; Draw some polymarkers.

    if(.not.any(ismissing(x)).and..not.any(ismissing(y)))
      NhlNDCPolymarker(canvas,gsid,x,y)
    else
      x2 = x(ind(.not.ismissing(x).and..not.ismissing(y)))
      y2 = y(ind(.not.ismissing(x).and..not.ismissing(y)))
      NhlNDCPolymarker(canvas,gsid,x2,y2)
    end if
end

;***********************************************************************;
; Function : gsn_streamline                                             ;
;                   wks: workstation object                             ;
;                     u: 2-dimensional U array                          ;
;                     v: 2-dimensional V array                          ;
;               resources: optional resources                           ;
;                                                                       ;
; This function creates and draws a streamline plot to the workstation  ;
; "wks" (the variable returned from a previous call to "gsn_open_wks"). ;
; "u" and "v" are the 2-dimensional arrays to be streamlined, and       ;
; "resources" is an optional list of resources. The id of the streamline;
; plot is returned.                                                     ;
;***********************************************************************;

function gsn_streamline(wks:graphic,u[*][*]:numeric,v[*][*]:numeric,\
                        resources:logical)
local i,attnames,data_object,plot_object,res,vf_res_index,st_res_index, \
force_xaxis_linear, force_yaxis_linear, force_xaxis_log, force_yaxis_log, \
trxmin, trxmax, trymin, trymax, tr_res_index, trres, res2
begin
    calldraw  = True
    callframe = True
    scale     = False
    shape     = False
    trres     = False
    res2      = resources

    force_xaxis_linear = False
    force_yaxis_linear = False
    force_xaxis_log    = False
    force_yaxis_log    = False

; Create the data object.

    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    data_object = create wksname + "_data" vectorFieldClass noparent
        "vfUDataArray" : u
        "vfVDataArray" : v
    end create

; Check for missing values.

    if(isatt(u,"_FillValue")) then
        setvalues data_object
            "vfMissingUValueV" :u@_FillValue
        end setvalues
    end if
    if(isatt(v,"_FillValue")) then
        setvalues data_object
            "vfMissingVValueV" :v@_FillValue
        end setvalues
    end if

; Create plot object.

    plot_object = create wksname + "_stream" streamlinePlotClass wks
        "stVectorFieldData" : data_object
    end create

    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False
            end if
            delete(res2@gsnDraw)
        end if
        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

; Check if the plot should be reshaped or scaled.

        if(isatt(res2,"gsnScale"))
            if(res2@gsnScale)
                scale = True
            end if
            delete(res2@gsnScale)
        end if

        if(isatt(res2,"gsnShape"))
            if(res2@gsnShape)
                shape = True
                scale = True
            end if
            delete(res2@gsnShape)
        end if

;
; Check if a linear or log axis is wanted (this should only be used if
; irregularly-spaced data is used for the X or Y axis (i.e. if vfXArray
; or vfYArray are set).
;
        if(isatt(res2,"gsnXAxisIrregular2Linear"))
          if(res2@gsnXAxisIrregular2Linear)
            force_xaxis_linear = True
          end if
          delete(res2@gsnXAxisIrregular2Linear)
        end if

        if(isatt(res2,"gsnYAxisIrregular2Linear"))
          if(res2@gsnYAxisIrregular2Linear)
            force_yaxis_linear = True
          end if
          delete(res2@gsnYAxisIrregular2Linear)
        end if

        if(isatt(res2,"gsnXAxisIrregular2Log"))
          if(res2@gsnXAxisIrregular2Log)
            force_xaxis_log = True
          end if
          delete(res2@gsnXAxisIrregular2Log)
        end if

        if(isatt(res2,"gsnYAxisIrregular2Log"))
          if(res2@gsnYAxisIrregular2Log)
            force_yaxis_log = True
          end if
          delete(res2@gsnYAxisIrregular2Log)
        end if

        if(force_yaxis_log.and.force_yaxis_linear)
         print("Error: gsn_streamline: you cannot set both gsnYAxisIrregular2Log")
         print("and gsnYAxisIrregular2Linear to True.")
         exit
       end if

        if(force_xaxis_log.and.force_xaxis_linear)
         print("Error: gsn_streamline: you cannot set both gsnXAxisIrregular2Log")
         print("and gsnXAxisIrregular2Linear to True.")
         exit
       end if

; Check if turning tickmarks off.

        if(isatt(res2,"gsnTickMarksOn"))
            if(.not.res2@gsnTickMarksOn)
              gsnp_turn_off_tickmarks(res2)
            end if
            delete(res2@gsnTickMarksOn)
        end if

    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
; Get list of resources.

        attnames = getvaratts(res2)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any data resources were set (these are resources that
; start with the two-letter index "vf").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."vf")
                setvalues data_object
                    attnames : res2@$attnames$
                end setvalues
            else
                setvalues plot_object
                    attnames : res2@$attnames$
                end setvalues
            end if
            if(force_xaxis_linear.or.force_xaxis_log.or. \
               force_yaxis_linear.or.force_yaxis_log)
              if(chartostring(res(0:1)).eq."tr")
                trres = True
                trres@$attnames$ = res2@$attnames$
              end if
            end if
        else
            vf_res_index = ind(chartostring(res(:,0:1)).eq."vf")
            st_res_index = ind(chartostring(res(:,0:1)).ne."vf")
            if(.not.all(ismissing(vf_res_index)))
                vfres = True
                do i = 0,dimsizes(vf_res_index)-1
                    vfres@$attnames(vf_res_index(i))$ = res2@$attnames(vf_res_index(i))$
                end do
                attsetvalues(data_object,vfres)
            end if
            if(.not.all(ismissing(st_res_index)))
                stres = True
                do i = 0,dimsizes(st_res_index)-1
                    stres@$attnames(st_res_index(i))$ = res2@$attnames(st_res_index(i))$
                end do
                attsetvalues(plot_object,stres)
            end if
            if(force_xaxis_linear.or.force_xaxis_log.or. \
               force_yaxis_linear.or.force_yaxis_log)
              tr_res_index = ind(chartostring(res(:,0:1)).eq."tr")
              if(.not.all(ismissing(tr_res_index)))
                  trres = True
                  do i = 0,dimsizes(tr_res_index)-1
                    trres@$attnames(tr_res_index(i))$ = res2@$attnames(tr_res_index(i))$
                  end do
              end if
            end if
        end if
    end if

;
; If gsnShape was set to True, then resize the X or Y axis so that
; the scales are proportionally correct.
; 
    if(shape)
        getvalues plot_object
          "vpXF"      : xf
          "vpYF"      : yf
          "vpWidthF"  : width
          "vpHeightF" : height
          "trXMinF"   : trxmin
          "trXMaxF"   : trxmax
          "trYMinF"   : trymin
          "trYMaxF"   : trymax
        end getvalues

        xrange = trxmax - trxmin
        yrange = trymax - trymin

        if(xrange.lt.yrange)
          new_width  = width * (xrange/yrange)
          new_height = height
          new_xf     = xf + 0.5*(width-new_width)
          new_yf     = yf
        else
          new_height = height * (yrange/xrange)
          new_width  = width
          new_yf     = yf - 0.5*(height-new_height)
          new_xf     = xf
        end if

        setvalues plot_object
          "vpXF"      : new_xf
          "vpYF"      : new_yf
          "vpWidthF"  : new_width
          "vpHeightF" : new_height
        end setvalues
    end if

;
; If gsnScale was set to True, then make sure the X and Y axis labels
; and tick marks are the same size.
; 
    if(scale)
        getvalues plot_object
          "tiXAxisFontHeightF"   : xfontf
          "tiYAxisFontHeightF"   : yfontf
          "tmXBLabelFontHeightF" : xbfontf
          "tmXBMajorLengthF"     : xlengthf
          "tmXBMinorLengthF"     : xmlengthf
          "tmYLLabelFontHeightF" : ylfontf
          "tmYLMajorLengthF"     : ylengthf
          "tmYLMinorLengthF"     : ymlengthf
        end getvalues

        setvalues plot_object
          "tiXAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tiYAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tmXBLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmXBMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmXBMinorLengthF"     : (ymlengthf+xmlengthf)/2.
          "tmYLLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmYLMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmYLMinorLengthF"     : (ymlengthf+xmlengthf)/2.
        end setvalues
    end if

; Check if we need to force the X or Y axis to be linear or log.
; If so, then we have to overlay it on a LogLin Plot.

     if(force_xaxis_linear.or.force_xaxis_log.or. \
        force_yaxis_linear.or.force_yaxis_log)

       overlay_plot_object = plot_object
       delete(plot_object)

       getvalues overlay_plot_object
         "trXMinF"    : trxmin
         "trXMaxF"    : trxmax
         "trYMinF"    : trymin
         "trYMaxF"    : trymax
       end getvalues

      plot_object = create wksname + "_loglin" logLinPlotClass wks
        "trXLog"  : force_xaxis_log
        "trYLog"  : force_yaxis_log
        "trXMinF" : trxmin
        "trXMaxF" : trxmax
        "trYMinF" : trymin
        "trYMaxF" : trymax
      end create
      if(trres)
        attsetvalues(plot_object,trres)
      end if

      overlay(plot_object,overlay_plot_object)
      plot_object@contour = overlay_plot_object
    end if

    if(calldraw)
        draw(plot_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object and data object (as attribute of plot object).

    plot_object@data = data_object
    return(plot_object)
end

;***********************************************************************;
; Function : gsn_streamline_map                                         ;
;                   wks: workstation object                             ;
;                     u: 2-dimensional U data                           ;
;                     v: 2-dimensional V data                           ;
;               resources: optional resources                           ;
;                                                                       ;
; This function creates and draws a streamline plot over a map plot to  ;
; the workstation "wks" (the variable returned from a previous call to  ;
; "gsn_open_wks").  "u" and "v" are the 2-dimensional arrays to be      ;
; streamlined, and "resources" is an optional list of resources. The id ;
; of the map plot is returned.                                          ;
;***********************************************************************;

function gsn_streamline_map(wks:graphic,u[*][*]:numeric,\
                            v[*][*]:numeric,resources:logical)
local i, attnames, data_object, contour_object, res, vf_res_index, \
st_res_index, mp_res_index, map_object, res2
begin
    calldraw = True
    callframe = True
    scale     = False
    res2      = resources

; Create the data object.

    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    data_object = create wksname + "_data" vectorFieldClass noparent
        "vfUDataArray" : u
        "vfVDataArray" : v
    end create

; Check for missing values.

    if(isatt(u,"_FillValue")) then
        setvalues data_object
            "vfMissingUValueV" :u@_FillValue
        end setvalues
    end if
    if(isatt(v,"_FillValue")) then
        setvalues data_object
            "vfMissingVValueV" :v@_FillValue
        end setvalues
    end if

; Create plot object.

    stream_object = create wksname + "_stream" streamlinePlotClass wks
        "stVectorFieldData" : data_object
    end create

; Create map object.

    map_object = create wksname + "_map" mapPlotClass wks
    end create

    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False
            end if
            delete(res2@gsnDraw)
        end if
        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

        if(isatt(res2,"gsnScale"))
            if(res2@gsnScale)
                scale = True
            end if
            delete(res2@gsnScale)
        end if
    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
; Get list of resources.

        attnames = getvaratts(res2)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))
        if(dimsizes(dimsizes(res)).eq.1)

;***********************************************************************;
; Check to see if any resources were set. For the data object,          ;
; resources begin with "vf". For the map object, resources begin with   ;
; "mp". For the streamline object, any resource that doesn't start with ;
; "mp" or "vf" is assumed to be a streamline or streamline-related      ;
; resource.                                                             ;
;***********************************************************************;

            if(chartostring(res(0:1)).eq."vf")
                setvalues data_object
                    attnames : res2@$attnames$
                end setvalues
            else
                if(chartostring(res(0:1)).eq."mp".or.\
                   chartostring(res(0:1)).eq."vp")
                    setvalues map_object
                        attnames : res2@$attnames$
                    end setvalues
                else 
                    setvalues stream_object
                        attnames : res2@$attnames$
                    end setvalues
                end if
            end if
        else
            vf_res_index = ind(chartostring(res(:,0:1)).eq."vf")
            mp_res_index = ind(chartostring(res(:,0:1)).eq."mp".or.\
                               chartostring(res(:,0:1)).eq."vp")
            st_res_index = ind(chartostring(res(:,0:1)).ne."mp".and.\
                               chartostring(res(:,0:1)).ne."vf".and.\
                               chartostring(res(:,0:1)).ne."vp")
            if(.not.all(ismissing(vf_res_index)))
                vfres = True
                do i = 0,dimsizes(vf_res_index)-1
                    vfres@$attnames(vf_res_index(i))$ = res2@$attnames(vf_res_index(i))$
                end do
                attsetvalues(data_object,vfres)
            end if
            if(.not.all(ismissing(mp_res_index)))
                mpres = True
                do i = 0,dimsizes(mp_res_index)-1
                    mpres@$attnames(mp_res_index(i))$ = res2@$attnames(mp_res_index(i))$
                end do
                attsetvalues(map_object,mpres)
            end if
            if(.not.all(ismissing(st_res_index)))
                stres = True
                do i = 0,dimsizes(st_res_index)-1
                    stres@$attnames(st_res_index(i))$ = res2@$attnames(st_res_index(i))$
                end do
                attsetvalues(stream_object,stres)
            end if
        end if
    end if

    overlay(map_object,stream_object)

;
; If gsnScale was set to True, then make sure the X and Y axis labels
; and tick marks are the same size.
; 
    if(scale)
        getvalues stream_object
          "tiXAxisFontHeightF"   : xfontf
          "tiYAxisFontHeightF"   : yfontf
          "tmXBLabelFontHeightF" : xbfontf
          "tmXBMajorLengthF"     : xlengthf
          "tmXBMinorLengthF"     : xmlengthf
          "tmYLLabelFontHeightF" : ylfontf
          "tmYLMajorLengthF"     : ylengthf
          "tmYLMinorLengthF"     : ymlengthf
        end getvalues

        setvalues stream_object
          "tiXAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tiYAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tmXBLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmXBMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmXBMinorLengthF"     : (ymlengthf+xmlengthf)/2.
          "tmYLLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmYLMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmYLMinorLengthF"     : (ymlengthf+xmlengthf)/2.
        end setvalues
    end if

    if(calldraw)
        draw(map_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object and data object (as attribute of plot object).

    map_object@data = data_object
    map_object@streamline = stream_object
    return(map_object)
end

;***********************************************************************;
; Procedure : gsn_text                                                  ;
;                   wks: workstation object                             ;
;                plotid: plot object                                    ;
;                  text: array of text strings                          ;
;                     x: 1-dimensional array of x data positions        ;
;                     y: 1-dimensional array of y data positions        ;
;               resources: optional resources                           ;
;                                                                       ;
; This procedure draws text strings on the workstation "wks" (the       ;
; variable returned from a previous call to "gsn_open_wks").  "x" and   ;
; "y" are the x and y locations of each text string, and should be      ;
; specified in the same data space as the data space of "plotid".       ;
; "resources" is an optional list of resources.                         ;
;***********************************************************************;

procedure gsn_text(wks:graphic, plotid:graphic, text:string, x:numeric, \
                   y:numeric, resources:logical )
local i, txid, attnames, plot_object, res, tx_res_index, x2, y2, funccode
begin

    x2 = new(dimsizes(x),float)
    y2 = new(dimsizes(y),float)
    datatondc(plotid,x,y,x2,y2)
;
; The "txFuncCode" can't be set during a setvalues  call. It must be
; set during the creation of the object.  
;
    if((resources).and.isatt(resources,"txFuncCode")) then
      funccode = resources@txFuncCode
    else
      funccode = ":"     ; The default.
    end if

    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    txid = create wksname + "_text" textItemClass wks
        "txString"   : text
        "txPosXF"    : x2
        "txPosYF"    : y2
        "txFuncCode" : funccode
    end create

    if((resources).and..not.any(ismissing(getvaratts(resources))))

; Get list of resources.

        attnames = getvaratts(resources)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any text item resources were set (these are resources
; that start with the two-letter index "tx").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."tx")
                setvalues txid
                    attnames : resources@$attnames$
                end setvalues
            end if
        else
            tx_res_index = ind(chartostring(res(:,0:1)).eq."tx")
            if(.not.all(ismissing(tx_res_index)))
                txres = True
                do i = 0,dimsizes(tx_res_index)-1
                    txres@$attnames(tx_res_index(i))$ = resources@$attnames(tx_res_index(i))$
                end do
                attsetvalues(txid,txres)
            end if
        end if
    end if

; Draw text string.

    draw(txid)
    delete(txid)
end

;***********************************************************************;
; Procedure : gsn_text_ndc                                              ;
;                   wks: workstation object                             ;
;                  text: array of text strings                          ;
;                     x: 1-dimensional array of x ndc positions         ;
;                     y: 1-dimensional array of y ndc positions         ;
;               resources: optional resources                           ;
;                                                                       ;
; This procedure draws text strings on the workstation "wks" (the       ;
; variable returned from a previous call to "gsn_open_wks").  "x" and   ;
; "y" are the x and y locations of each text string, and should be      ;
; specified in NDC space. "resources" is an optional list of resources. ;
;***********************************************************************;

procedure gsn_text_ndc(wks:graphic, text:string, x:numeric, \
                   y:numeric, resources:logical )
local i, txid, attnames, plot_object, res, tx_res_index, x2, y2
begin

    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    if((resources).and.isatt(resources,"txFuncCode")) then
      txid = create wksname + "_text_ndc" textItemClass wks
        "txString" : text
        "txPosXF"  : x
        "txPosYF"  : y
        "txFuncCode" : resources@txFuncCode
      end create
    else
      txid = create wksname + "_text_ndc" textItemClass wks
        "txString" : text
        "txPosXF"  : x
        "txPosYF"  : y
      end create
    end if

    if((resources).and..not.any(ismissing(getvaratts(resources))))

; Get list of resources.

        attnames = getvaratts(resources)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any text item resources were set (these are resources
; that start with the two-letter index "tx").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."tx")
                setvalues txid
                    attnames : resources@$attnames$
                end setvalues
            end if
        else
            tx_res_index = ind(chartostring(res(:,0:1)).eq."tx")
            if(.not.all(ismissing(tx_res_index)))
                txres = True
                do i = 0,dimsizes(tx_res_index)-1
                    txres@$attnames(tx_res_index(i))$ = resources@$attnames(tx_res_index(i))$
                end do
                attsetvalues(txid,txres)
            end if
        end if
    end if

; Draw text string.

    draw(txid)
    delete(txid)
end

;***********************************************************************;
; Function : gsn_vector                                                 ;
;                   wks: workstation object                             ;
;                     u: 2-dimensional U array                          ;
;                     v: 2-dimensional V array                          ;
;               resources: optional resources                           ;
;                                                                       ;
; This function creates and draws a vector plot to the workstation "wks";
; (the variable returned from a previous call to "gsn_open_wks").  "u"  ;
; and "v" are the 2-dimensional arrays to be vectorized, and "resources";
; is an optional list of resources. The id of the vector plot is        ;
; returned.                                                             ;
;***********************************************************************;

function gsn_vector(wks:graphic, u[*][*]:numeric, v[*][*]:numeric, \
                    resources:logical )
local i,attnames,data_object,plot_object,res,vf_res_index,vc_res_index, \
force_xaxis_linear, force_yaxis_linear, force_xaxis_log, force_yaxis_log, \
trxmin, trxmax, trymin, trymax, tr_res_index, trres, res2
begin
    calldraw = True
    callframe = True
    scale     = False
    shape     = False
    trres     = False
    res2      = resources

    force_xaxis_linear = False
    force_yaxis_linear = False
    force_xaxis_log    = False
    force_yaxis_log    = False

; Create the data object.

    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    data_object = create wksname + "_data" vectorFieldClass noparent
        "vfUDataArray" : u
        "vfVDataArray" : v
    end create

; Check for missing values.

    if(isatt(u,"_FillValue")) then
        setvalues data_object
            "vfMissingUValueV" :u@_FillValue
        end setvalues
    end if
    if(isatt(v,"_FillValue")) then
        setvalues data_object
            "vfMissingVValueV" :v@_FillValue
        end setvalues
    end if

; Create plot object.

    plot_object = create wksname + "_vector" vectorPlotClass wks
        "vcVectorFieldData" : data_object
    end create

    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False    
        end if
            delete(res2@gsnDraw)
        end if
        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

; Check if the plot should be reshaped or scaled.

        if(isatt(res2,"gsnScale"))
            if(res2@gsnScale)
                scale = True
            end if
            delete(res2@gsnScale)
        end if

        if(isatt(res2,"gsnShape"))
            if(res2@gsnShape)
                shape = True
                scale = True
            end if
            delete(res2@gsnShape)
        end if

;
; Check if a linear or log axis is wanted (this should only be used if
; irregularly-spaced data is used for the X or Y axis (i.e. if vfXArray
; or vfYArray are set).
;
        if(isatt(res2,"gsnXAxisIrregular2Linear"))
          if(res2@gsnXAxisIrregular2Linear)
            force_xaxis_linear = True
          end if
          delete(res2@gsnXAxisIrregular2Linear)
        end if

        if(isatt(res2,"gsnYAxisIrregular2Linear"))
          if(res2@gsnYAxisIrregular2Linear)
            force_yaxis_linear = True
          end if
          delete(res2@gsnYAxisIrregular2Linear)
        end if

        if(isatt(res2,"gsnXAxisIrregular2Log"))
          if(res2@gsnXAxisIrregular2Log)
            force_xaxis_log = True
          end if
          delete(res2@gsnXAxisIrregular2Log)
        end if

        if(isatt(res2,"gsnYAxisIrregular2Log"))
          if(res2@gsnYAxisIrregular2Log)
            force_yaxis_log = True
          end if
          delete(res2@gsnYAxisIrregular2Log)
        end if

        if(force_yaxis_log.and.force_yaxis_linear)
         print("Error: gsn_vector: you cannot set both gsnYAxisIrregular2Log")
         print("and gsnYAxisIrregular2Linear to True.")
         exit
       end if

        if(force_xaxis_log.and.force_xaxis_linear)
         print("Error: gsn_vector: you cannot set both gsnXAxisIrregular2Log")
         print("and gsnXAxisIrregular2Linear to True.")
         exit
       end if

; Check if turning tickmarks off.

        if(isatt(res2,"gsnTickMarksOn"))
            if(.not.res2@gsnTickMarksOn)
              gsnp_turn_off_tickmarks(res2)
            end if
            delete(res2@gsnTickMarksOn)
        end if

    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
; Get list of resources.

        attnames = getvaratts(res2)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any data resources were set (these are resources that
; start with the two-letter index "vf").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."vf")
                setvalues data_object
                    attnames : res2@$attnames$
                end setvalues
            else
                setvalues plot_object
                    attnames : res2@$attnames$
                end setvalues
            end if
            if(force_xaxis_linear.or.force_xaxis_log.or. \
               force_yaxis_linear.or.force_yaxis_log)
              if(chartostring(res(0:1)).eq."tr")
                trres = True
                trres@$attnames$ = res2@$attnames$
              end if
            end if
        else
            vf_res_index = ind(chartostring(res(:,0:1)).eq."vf")
            vc_res_index = ind(chartostring(res(:,0:1)).ne."vf")
            if(.not.all(ismissing(vf_res_index)))
                vfres = True
                do i = 0,dimsizes(vf_res_index)-1
                    vfres@$attnames(vf_res_index(i))$ = res2@$attnames(vf_res_index(i))$
                end do
                attsetvalues(data_object,vfres)
            end if
            if(.not.all(ismissing(vc_res_index)))
                vcres = True
                do i = 0,dimsizes(vc_res_index)-1
                    vcres@$attnames(vc_res_index(i))$ = res2@$attnames(vc_res_index(i))$
                end do
                attsetvalues(plot_object,vcres)
            end if
            if(force_xaxis_linear.or.force_xaxis_log.or. \
               force_yaxis_linear.or.force_yaxis_log)
              tr_res_index = ind(chartostring(res(:,0:1)).eq."tr")
              if(.not.all(ismissing(tr_res_index)))
                  trres = True
                  do i = 0,dimsizes(tr_res_index)-1
                    trres@$attnames(tr_res_index(i))$ = res2@$attnames(tr_res_index(i))$
                  end do
              end if
            end if
        end if
    end if

;
; If gsnShape was set to True, then resize the X or Y axis so that
; the scales are proportionally correct.
; 
    if(shape)
        getvalues plot_object
          "vpXF"      : xf
          "vpYF"      : yf
          "vpWidthF"  : width
          "vpHeightF" : height
          "trXMinF"   : trxmin
          "trXMaxF"   : trxmax
          "trYMinF"   : trymin
          "trYMaxF"   : trymax
        end getvalues

        xrange = trxmax - trxmin
        yrange = trymax - trymin

        if(xrange.lt.yrange)
          new_width  = width * (xrange/yrange)
          new_height = height
          new_xf     = xf + 0.5*(width-new_width)
          new_yf     = yf
        else
          new_height = height * (yrange/xrange)
          new_width  = width
          new_yf     = yf - 0.5*(height-new_height)
          new_xf     = xf
        end if

        setvalues plot_object
          "vpXF"      : new_xf
          "vpYF"      : new_yf
          "vpWidthF"  : new_width
          "vpHeightF" : new_height
        end setvalues
    end if

;
; If gsnScale was set to True, then make sure the X and Y axis labels
; and tick marks are the same size.
; 
    if(scale)
        getvalues plot_object
          "tiXAxisFontHeightF"   : xfontf
          "tiYAxisFontHeightF"   : yfontf
          "tmXBLabelFontHeightF" : xbfontf
          "tmXBMajorLengthF"     : xlengthf
          "tmXBMinorLengthF"     : xmlengthf
          "tmYLLabelFontHeightF" : ylfontf
          "tmYLMajorLengthF"     : ylengthf
          "tmYLMinorLengthF"     : ymlengthf
        end getvalues

        setvalues plot_object
          "tiXAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tiYAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tmXBLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmXBMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmXBMinorLengthF"     : (ymlengthf+xmlengthf)/2.
          "tmYLLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmYLMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmYLMinorLengthF"     : (ymlengthf+xmlengthf)/2.
        end setvalues
    end if

; Check if we need to force the X or Y axis to be linear or log.
; If so, then we have to overlay it on a LogLin Plot.

     if(force_xaxis_linear.or.force_xaxis_log.or. \
        force_yaxis_linear.or.force_yaxis_log)

       overlay_plot_object = plot_object
       delete(plot_object)

       getvalues overlay_plot_object
         "trXMinF"    : trxmin
         "trXMaxF"    : trxmax
         "trYMinF"    : trymin
         "trYMaxF"    : trymax
       end getvalues

      plot_object = create wksname + "_loglin" logLinPlotClass wks
        "trXLog"  : force_xaxis_log
        "trYLog"  : force_yaxis_log
        "trXMinF" : trxmin
        "trXMaxF" : trxmax
        "trYMinF" : trymin
        "trYMaxF" : trymax
      end create
      if(trres)
        attsetvalues(plot_object,trres)
      end if

      overlay(plot_object,overlay_plot_object)
      plot_object@contour = overlay_plot_object
    end if

    if(calldraw)
        draw(plot_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object and data object (as attribute of plot object).

    plot_object@data = data_object
    return(plot_object)
end

;***********************************************************************;
; Function : gsn_vector_contour                                         ;
;                   wks: workstation object                             ;
;                     u: 2-dimensional U data                           ;
;                     v: 2-dimensional V data                           ;
;                  data: 2-dimensional scalar field                     ;
;               resources: optional resources                           ;
;                                                                       ;
; This function creates and draws vectors and contours over a map plot  ;
; to the workstation "wks" (the variable returned from a previous call  ;
; to "gsn_open_wks").  "u" and "v" are the 2-dimensional arrays to be   ;
; vectorized, and "data" is the scalar field to be contoured.           ;
; "resources" is an optional list of resources. The id of the map plot  ;
; is returned.                                                          ;
;***********************************************************************;

function gsn_vector_contour(wks:graphic,u[*][*]:numeric,\
                            v[*][*]:numeric,data[*][*]:numeric,\
                            resources:logical)
local i, attnames, vfdata_object, sfdata_object, contour_object, res, \
vf_res_index, vc_res_index, sf_res_index, res2
begin
    calldraw = True
    callframe = True
    scale     = False
    res2      = resources

;
; Create the vector field object.
;
    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    vfdata_object = create wksname + "_vfdata" vectorFieldClass noparent
        "vfUDataArray" : u
        "vfVDataArray" : v
    end create

;
; Check for missing values.
;
    if(isatt(u,"_FillValue")) then
        setvalues vfdata_object
            "vfMissingUValueV" :u@_FillValue
        end setvalues
    end if
    if(isatt(v,"_FillValue")) then
        setvalues vfdata_object
            "vfMissingVValueV" :v@_FillValue
        end setvalues
    end if

; Create the scalar field object.

    sfdata_object = create wksname + "_sfdata" scalarFieldClass noparent
        "sfDataArray" : data
    end create

; Check for a missing value.

    if(isatt(data,"_FillValue")) then
        setvalues sfdata_object
            "sfMissingValueV" :data@_FillValue
        end setvalues
    end if

; Create vector plot object.

    vector_object = create wksname + "_vector" vectorPlotClass wks
        "vcVectorFieldData" : vfdata_object
    end create

; Create contour plot object.

    contour_object = create wksname + "_contour" contourPlotClass wks
        "cnScalarFieldData" : sfdata_object
    end create

    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False
            end if
            delete(res2@gsnDraw)
        end if
        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

        if(isatt(res2,"gsnScale"))
            if(res2@gsnScale)
                scale = True
            end if
            delete(res2@gsnScale)
        end if
    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
; Get list of resources.

        attnames = getvaratts(res2)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))
        if(dimsizes(dimsizes(res)).eq.1)

;***********************************************************************;
; Check to see if any resources were set. For the vector field data     ;
; object, resources begin with "vf" and for the scalar field data       ;
; object, resources being with "sf". For the contour ojbect, resources  ;
; begin with "cn" and for the vector object, any resource that doesn't  ;
; start with "cn" or "vf" is assumed to be a vector or vector-related   ;
; resource.                                                             ;
;***********************************************************************;

            if(chartostring(res(0:1)).eq."vf")
                setvalues vfdata_object
                    attnames : res2@$attnames$
                end setvalues
            else
                if(chartostring(res(0:1)).eq."sf")
                    setvalues sfdata_object
                        attnames : res2@$attnames$
                    end setvalues
                else
                  if(chartostring(res(0:1)).eq."cn".or.\
                     chartostring(res(0:1)).eq."vp")
                      setvalues contour_object
                          attnames : res2@$attnames$
                      end setvalues
                  else
                    setvalues vector_object
                      attnames : res2@$attnames$
                    end setvalues
                  end if
                end if
            end if
        else
            vf_res_index = ind(chartostring(res(:,0:1)).eq."vf")
            sf_res_index = ind(chartostring(res(:,0:1)).eq."sf")
            cn_res_index = ind(chartostring(res(:,0:1)).eq."cn".or.\
                               chartostring(res(:,0:1)).eq."vp")
            vc_res_index = ind(chartostring(res(:,0:1)).ne."vf".and.\
                               chartostring(res(:,0:1)).ne."cn".and.\
                               chartostring(res(:,0:1)).ne."sf".and.\
                               chartostring(res(:,0:1)).ne."vp")
            if(.not.all(ismissing(vf_res_index)))
                vfres = True
                do i = 0,dimsizes(vf_res_index)-1
                    vfres@$attnames(vf_res_index(i))$ = res2@$attnames(vf_res_index(i))$
                end do
                attsetvalues(vfdata_object,vfres)
            end if
            if(.not.all(ismissing(sf_res_index)))
                sfres = True
                do i = 0,dimsizes(sf_res_index)-1
                    sfres@$attnames(sf_res_index(i))$ = res2@$attnames(sf_res_index(i))$
                end do
                attsetvalues(sfdata_object,sfres)
            end if
            if(.not.all(ismissing(cn_res_index)))
                cnres = True
                do i = 0,dimsizes(cn_res_index)-1
                    cnres@$attnames(cn_res_index(i))$ = res2@$attnames(cn_res_index(i))$
                end do
                attsetvalues(contour_object,cnres)
            end if
            if(.not.all(ismissing(vc_res_index)))
                vcres = True
                do i = 0,dimsizes(vc_res_index)-1
                    vcres@$attnames(vc_res_index(i))$ = res2@$attnames(vc_res_index(i))$
                end do
                attsetvalues(vector_object,vcres)
            end if
        end if
    end if

    overlay(contour_object,vector_object)

;
; If gsnScale was set to True, then make sure the X and Y axis labels
; and tick marks are the same size.
; 
    if(scale)
        getvalues vector_object
          "tiXAxisFontHeightF"   : xfontf
          "tiYAxisFontHeightF"   : yfontf
          "tmXBLabelFontHeightF" : xbfontf
          "tmXBMajorLengthF"     : xlengthf
          "tmXBMinorLengthF"     : xmlengthf
          "tmYLLabelFontHeightF" : ylfontf
          "tmYLMajorLengthF"     : ylengthf
          "tmYLMinorLengthF"     : ymlengthf
        end getvalues

        setvalues vector_object
          "tiXAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tiYAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tmXBLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmXBMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmXBMinorLengthF"     : (ymlengthf+xmlengthf)/2.
          "tmYLLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmYLMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmYLMinorLengthF"     : (ymlengthf+xmlengthf)/2.
        end setvalues
    end if

    if(calldraw)
        draw(contour_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object and data object (as attribute of plot object).

    contour_object@vfdata = vfdata_object
    contour_object@sfdata = sfdata_object
    contour_object@vector = vector_object
    return(contour_object)
end

;***********************************************************************;
; Function : gsn_vector_contour_map                                     ;
;                   wks: workstation object                             ;
;                     u: 2-dimensional U data                           ;
;                     v: 2-dimensional V data                           ;
;                  data: 2-dimensional scalar field                     ;
;               resources: optional resources                           ;
;                                                                       ;
; This function creates and draws vectors and contours over a map plot  ;
; to the workstation "wks" (the variable returned from a previous call  ;
; to "gsn_open_wks").  "u" and "v" are the 2-dimensional arrays to be   ;
; vectorized, and "data" is the scalar field to be contoured.           ;
; "resources" is an optional list of resources. The id of the map plot  ;
; is returned.                                                          ;
;***********************************************************************;

function gsn_vector_contour_map(wks:graphic,u[*][*]:numeric,\
                               v[*][*]:numeric,data[*][*]:numeric,\
                               resources:logical)
local i, attnames, vfdata_object, sfdata_object, contour_object, res, \
vf_res_index, vc_res_index, sf_res_index, mp_res_index, map_object, res2
begin
    calldraw = True
    callframe = True
    scale     = False
    res2      = resources

;
; Create the vector field object.
;
    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    vfdata_object = create wksname + "_vfdata" vectorFieldClass noparent
        "vfUDataArray" : u
        "vfVDataArray" : v
    end create

;
; Check for missing values.
;
    if(isatt(u,"_FillValue")) then
        setvalues vfdata_object
            "vfMissingUValueV" :u@_FillValue
        end setvalues
    end if
    if(isatt(v,"_FillValue")) then
        setvalues vfdata_object
            "vfMissingVValueV" :v@_FillValue
        end setvalues
    end if

; Create the scalar field object.

    sfdata_object = create wksname + "_sfdata" scalarFieldClass noparent
        "sfDataArray" : data
    end create

; Check for a missing value.

    if(isatt(data,"_FillValue")) then
        setvalues sfdata_object
            "sfMissingValueV" :data@_FillValue
        end setvalues
    end if

; Create vector plot object.

    vector_object = create wksname + "_vector" vectorPlotClass wks
        "vcVectorFieldData" : vfdata_object
    end create

; Create contour plot object.

    contour_object = create wksname + "_contour" contourPlotClass wks
        "cnScalarFieldData" : sfdata_object
    end create

; Create map object.

    map_object = create wksname + "_map" mapPlotClass wks end create

    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False
            end if
            delete(res2@gsnDraw)
        end if
        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

        if(isatt(res2,"gsnScale"))
            if(res2@gsnScale)
                scale = True
            end if
            delete(res2@gsnScale)
        end if
    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
; Get list of resources.

        attnames = getvaratts(res2)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))
        if(dimsizes(dimsizes(res)).eq.1)

;***********************************************************************;
; Check to see if any resources were set. For the vector field data     ;
; object, resources begin with "vf" and for the scalar field data       ;
; object, resources being with "sf". For the map object, resources begin;
; with "mp". For the contour ojbect, resources begin with "cn" and for  ;
; the vector object, any resource that doesn't start with "mp", "cn", or;
; "vf" is assumed to be a vector or vector-related resource.            ;
;***********************************************************************;

            if(chartostring(res(0:1)).eq."vf")
                setvalues vfdata_object
                    attnames : res2@$attnames$
                end setvalues
            else
                if(chartostring(res(0:1)).eq."sf")
                    setvalues sfdata_object
                        attnames : res2@$attnames$
                    end setvalues
                else
                    if(chartostring(res(0:1)).eq."mp".or.\
                       chartostring(res(0:1)).eq."vp")
                        setvalues map_object
                            attnames : res2@$attnames$
                        end setvalues
                    else 
                      if(chartostring(res(0:1)).eq."cn")
                          setvalues contour_object
                              attnames : res2@$attnames$
                          end setvalues
                      else
                        setvalues vector_object
                        attnames : res2@$attnames$
                        end setvalues
                      end if
                    end if
                end if
            end if
        else
            vf_res_index = ind(chartostring(res(:,0:1)).eq."vf")
            sf_res_index = ind(chartostring(res(:,0:1)).eq."sf")
            cn_res_index = ind(chartostring(res(:,0:1)).eq."cn")
            mp_res_index = ind(chartostring(res(:,0:1)).eq."mp".or.\
                               chartostring(res(:,0:1)).eq."vp")
            vc_res_index = ind(chartostring(res(:,0:1)).ne."mp".and.\
                               chartostring(res(:,0:1)).ne."vf".and.\
                               chartostring(res(:,0:1)).ne."cn".and.\
                               chartostring(res(:,0:1)).ne."sf".and.\
                               chartostring(res(:,0:1)).ne."vp")
            if(.not.all(ismissing(vf_res_index)))
                vfres = True
                do i = 0,dimsizes(vf_res_index)-1
                    vfres@$attnames(vf_res_index(i))$ = res2@$attnames(vf_res_index(i))$
                end do
                attsetvalues(vfdata_object,vfres)
            end if
            if(.not.all(ismissing(sf_res_index)))
                sfres = True
                do i = 0,dimsizes(sf_res_index)-1
                    sfres@$attnames(sf_res_index(i))$ = res2@$attnames(sf_res_index(i))$
                end do
                attsetvalues(sfdata_object,sfres)
            end if
            if(.not.all(ismissing(mp_res_index)))
                mpres = True
                do i = 0,dimsizes(mp_res_index)-1
                    mpres@$attnames(mp_res_index(i))$ = res2@$attnames(mp_res_index(i))$
                end do
                attsetvalues(map_object,mpres)
            end if
            if(.not.all(ismissing(cn_res_index)))
                cnres = True
                do i = 0,dimsizes(cn_res_index)-1
                    cnres@$attnames(cn_res_index(i))$ = res2@$attnames(cn_res_index(i))$
                end do
                attsetvalues(contour_object,cnres)
            end if
            if(.not.all(ismissing(vc_res_index)))
                vcres = True
                do i = 0,dimsizes(vc_res_index)-1
                    vcres@$attnames(vc_res_index(i))$ = res2@$attnames(vc_res_index(i))$
                end do
                attsetvalues(vector_object,vcres)
            end if
        end if
    end if

    overlay(map_object,contour_object)
    overlay(map_object,vector_object)

;
; If gsnScale was set to True, then make sure the X and Y axis labels
; and tick marks are the same size.
; 
    if(scale)
        getvalues vector_object
          "tiXAxisFontHeightF"   : xfontf
          "tiYAxisFontHeightF"   : yfontf
          "tmXBLabelFontHeightF" : xbfontf
          "tmXBMajorLengthF"     : xlengthf
          "tmXBMinorLengthF"     : xmlengthf
          "tmYLLabelFontHeightF" : ylfontf
          "tmYLMajorLengthF"     : ylengthf
          "tmYLMinorLengthF"     : ymlengthf
        end getvalues

        setvalues vector_object
          "tiXAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tiYAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tmXBLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmXBMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmXBMinorLengthF"     : (ymlengthf+xmlengthf)/2.
          "tmYLLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmYLMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmYLMinorLengthF"     : (ymlengthf+xmlengthf)/2.
        end setvalues
    end if

    if(calldraw)
        draw(map_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object and data object (as attribute of plot object).

    map_object@vfdata = vfdata_object
    map_object@sfdata = sfdata_object
    map_object@vector = vector_object
    map_object@contour = contour_object
    return(map_object)
end

;***********************************************************************;
; Function : gsn_vector_map                                             ;
;                   wks: workstation object                             ;
;                     : 2-dimensional U data                            ;
;                     v: 2-dimensional V data                           ;
;               resources: optional resources                           ;
;                                                                       ;
; This function creates and draws a vector plot over a map plot to the  ;
; workstation "wks" (the variable returned from a previous call to      ;
; "gsn_open_wks").  "u" and "v" are the 2-dimensional arrays to be      ;
; vectorized, and "resources" is an optional list of resources. The id  ;
; of the map plot is returned.                                          ;
;***********************************************************************;

function gsn_vector_map(wks:graphic, u[*][*]:numeric, v[*][*]:numeric, \
                        resources:logical )
local i, attnames, data_object, contour_object, res, vf_res_index, \
vc_res_index, mp_res_index, map_object, res2
begin
    calldraw = True
    callframe = True
    scale     = False
    res2      = resources

; Create the data object.

    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    data_object = create wksname + "_data" vectorFieldClass noparent
        "vfUDataArray" : u
        "vfVDataArray" : v
    end create

; Check for missing values.

    if(isatt(u,"_FillValue")) then
        setvalues data_object
            "vfMissingUValueV" :u@_FillValue
        end setvalues
    end if
    if(isatt(v,"_FillValue")) then
        setvalues data_object
            "vfMissingVValueV" :v@_FillValue
        end setvalues
    end if

; Create plot object.

    vector_object = create wksname + "_vector" vectorPlotClass wks
        "vcVectorFieldData" : data_object
    end create

; Create map object.

    map_object = create wksname + "_map" mapPlotClass wks
    end create

    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False
            end if
            delete(res2@gsnDraw)
        end if
        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

        if(isatt(res2,"gsnScale"))
            if(res2@gsnScale)
                scale = True
            end if
            delete(res2@gsnScale)
        end if
    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
; Get list of resources.

        attnames = getvaratts(res2)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))
        if(dimsizes(dimsizes(res)).eq.1)

;***********************************************************************;
; Check to see if any resources were set. For the data object, resources;
; begin with "vf". For the map object, resources begin with "mp". For   ;
; the vector object, any resource that doesn't start with "mp" or "vf"  ;
; is assumed to be a vector or vector-related resource.                 ;
;***********************************************************************;

            if(chartostring(res(0:1)).eq."vf")
                setvalues data_object
                    attnames : res2@$attnames$
                end setvalues
            else
                if(chartostring(res(0:1)).eq."mp".or.\
                   chartostring(res(0:1)).eq."vp")
                    setvalues map_object
                        attnames : res2@$attnames$
                    end setvalues
                else 
                    setvalues vector_object
                        attnames : res2@$attnames$
                    end setvalues
                end if
            end if
        else
            vf_res_index = ind(chartostring(res(:,0:1)).eq."vf")
            mp_res_index = ind(chartostring(res(:,0:1)).eq."mp".or.\
                               chartostring(res(:,0:1)).eq."vp")
            vc_res_index = ind(chartostring(res(:,0:1)).ne."mp".and.\
                               chartostring(res(:,0:1)).ne."vf".and.\
                               chartostring(res(:,0:1)).ne."vp")
            if(.not.all(ismissing(vf_res_index)))
                vfres = True
                do i = 0,dimsizes(vf_res_index)-1
                    vfres@$attnames(vf_res_index(i))$ = res2@$attnames(vf_res_index(i))$
                end do
                attsetvalues(data_object,vfres)
            end if
            if(.not.all(ismissing(mp_res_index)))
                mpres = True
                do i = 0,dimsizes(mp_res_index)-1
                    mpres@$attnames(mp_res_index(i))$ = res2@$attnames(mp_res_index(i))$
                end do
                attsetvalues(map_object,mpres)
            end if
            if(.not.all(ismissing(vc_res_index)))
                vcres = True
                do i = 0,dimsizes(vc_res_index)-1
                    vcres@$attnames(vc_res_index(i))$ = res2@$attnames(vc_res_index(i))$
                end do
                attsetvalues(vector_object,vcres)
            end if
        end if
    end if

    overlay(map_object,vector_object)

;
; If gsnScale was set to True, then make sure the X and Y axis labels
; and tick marks are the same size.
; 
    if(scale)
        getvalues vector_object
          "tiXAxisFontHeightF"   : xfontf
          "tiYAxisFontHeightF"   : yfontf
          "tmXBLabelFontHeightF" : xbfontf
          "tmXBMajorLengthF"     : xlengthf
          "tmXBMinorLengthF"     : xmlengthf
          "tmYLLabelFontHeightF" : ylfontf
          "tmYLMajorLengthF"     : ylengthf
          "tmYLMinorLengthF"     : ymlengthf
        end getvalues

        setvalues vector_object
          "tiXAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tiYAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tmXBLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmXBMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmXBMinorLengthF"     : (ymlengthf+xmlengthf)/2.
          "tmYLLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmYLMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmYLMinorLengthF"     : (ymlengthf+xmlengthf)/2.
        end setvalues
    end if

    if(calldraw)
        draw(map_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object and data object (as attribute of plot object).

    map_object@data = data_object
    map_object@vector = vector_object
    return(map_object)
end

;***********************************************************************;
; Function : gsn_vector_scalar                                          ;
;                   wks: workstation object                             ;
;                     u: 2-dimensional U array                          ;
;                     v: 2-dimensional V array                          ;
;                  data: 2-dimensional scalar field                     ;
;               resources: optional resources                           ;
;                                                                       ;
; This function creates and draws a vector plot to the workstation "wks";
; (the variable returned from a previous call to "gsn_open_wks").  "u"  ;
; and "v" are the 2-dimensional arrays to be vectorized, and "data" is  ;
; the scalar field that the vectors are colored by. "resources" is an   ;
; optional list of resources. The id of the vector plot is returned.    ;
;***********************************************************************;

function gsn_vector_scalar(wks:graphic,u[*][*]:numeric,v[*][*]:numeric,\
                           data[*][*]:numeric, resources:logical )
local i, attnames, vfdata_object, sfdata_object, plot_object, res, \
force_xaxis_linear, force_yaxis_linear, force_xaxis_log, force_yaxis_log, \
trxmin, trxmax, trymin, trymax, tr_res_index, trres, vf_res_index, \
vc_res_index, sf_res_index, res2
begin
    calldraw = True
    callframe = True
    scale     = False
    shape     = False
    trres     = False
    res2      = resources

    force_xaxis_linear = False
    force_yaxis_linear = False
    force_xaxis_log    = False
    force_yaxis_log    = False

; Create the vector field data object.

    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    vfdata_object = create wksname + "_vfdata" vectorFieldClass noparent
        "vfUDataArray" : u
        "vfVDataArray" : v
    end create

; Create the scalar field data object.

    sfdata_object = create wksname + "_sfdata" scalarFieldClass noparent
        "sfDataArray" : data
    end create

; Check for a missing value.

    if(isatt(data,"_FillValue")) then
        setvalues sfdata_object
            "sfMissingValueV" :data@_FillValue
        end setvalues
    end if

; Check for missing values.

    if(isatt(u,"_FillValue")) then
        setvalues vfdata_object
            "vfMissingUValueV" :u@_FillValue
        end setvalues
    end if
    if(isatt(v,"_FillValue")) then
        setvalues vfdata_object
            "vfMissingVValueV" :v@_FillValue
        end setvalues
    end if

; Create plot object.

    plot_object = create wksname + "_vector" vectorPlotClass wks
        "vcVectorFieldData"     : vfdata_object
        "vcScalarFieldData"     : sfdata_object
        "vcUseScalarArray"      : True
        "vcMonoLineArrowColor"  : "false"
    end create

    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False
            end if
            delete(res2@gsnDraw)
        end if
        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

; Check if the plot should be reshaped or scaled.

        if(isatt(res2,"gsnScale"))
            if(res2@gsnScale)
                scale = True
            end if
            delete(res2@gsnScale)
        end if

        if(isatt(res2,"gsnShape"))
            if(res2@gsnShape)
                shape = True
                scale = True
            end if
            delete(res2@gsnShape)
        end if

;
; Check if a linear or log axis is wanted (this should only be used if
; irregularly-spaced data is used for the X or Y axis (i.e. if vfXArray
; or vfYArray are set).
;
        if(isatt(res2,"gsnXAxisIrregular2Linear"))
          if(res2@gsnXAxisIrregular2Linear)
            force_xaxis_linear = True
          end if
          delete(res2@gsnXAxisIrregular2Linear)
        end if

        if(isatt(res2,"gsnYAxisIrregular2Linear"))
          if(res2@gsnYAxisIrregular2Linear)
            force_yaxis_linear = True
          end if
          delete(res2@gsnYAxisIrregular2Linear)
        end if

        if(isatt(res2,"gsnXAxisIrregular2Log"))
          if(res2@gsnXAxisIrregular2Log)
            force_xaxis_log = True
          end if
          delete(res2@gsnXAxisIrregular2Log)
        end if

        if(isatt(res2,"gsnYAxisIrregular2Log"))
          if(res2@gsnYAxisIrregular2Log)
            force_yaxis_log = True
          end if
          delete(res2@gsnYAxisIrregular2Log)
        end if

        if(force_yaxis_log.and.force_yaxis_linear)
         print("Error: gsn_vector_scalar: you cannot set both gsnYAxisIrregular2Log")
         print("and gsnYAxisIrregular2Linear to True.")
         exit
       end if

        if(force_xaxis_log.and.force_xaxis_linear)
         print("Error: gsn_vector_scalar: you cannot set both gsnXAxisIrregular2Log")
         print("and gsnXAxisIrregular2Linear to True.")
         exit
       end if

; Check if turning tickmarks off.

        if(isatt(res2,"gsnTickMarksOn"))
            if(.not.res2@gsnTickMarksOn)
              gsnp_turn_off_tickmarks(res2)
            end if
            delete(res2@gsnTickMarksOn)
        end if

    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
; Get list of resources.

        attnames = getvaratts(res2)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any data resources were set (these are resources that
; start with the two-letter index "vf").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."vf")
                setvalues vfdata_object
                    attnames : res2@$attnames$
                end setvalues
            else
                if(chartostring(res(0:1)).eq."sf")
                    setvalues sfdata_object
                        attnames : res2@$attnames$
                    end setvalues
                else
                    setvalues plot_object
                        attnames : res2@$attnames$
                    end setvalues
                end if
            end if
            if(force_xaxis_linear.or.force_xaxis_log.or. \
               force_yaxis_linear.or.force_yaxis_log)
              if(chartostring(res(0:1)).eq."tr")
                trres = True
                trres@$attnames$ = res2@$attnames$
              end if
            end if
        else
            vf_res_index = ind(chartostring(res(:,0:1)).eq."vf")
            sf_res_index = ind(chartostring(res(:,0:1)).eq."sf")
            vc_res_index = ind(chartostring(res(:,0:1)).ne."vf".and.\
                               chartostring(res(:,0:1)).ne."sf")
            if(.not.all(ismissing(vf_res_index)))
                vfres = True
                do i = 0,dimsizes(vf_res_index)-1
                    vfres@$attnames(vf_res_index(i))$ = res2@$attnames(vf_res_index(i))$
                end do
                attsetvalues(vfdata_object,vfres)
            end if
            if(.not.all(ismissing(sf_res_index)))
                sfres = True
                do i = 0,dimsizes(sf_res_index)-1
                    sfres@$attnames(sf_res_index(i))$ = res2@$attnames(sf_res_index(i))$
                end do
                attsetvalues(sfdata_object,sfres)
            end if
            if(.not.all(ismissing(vc_res_index)))
                vcres = True
                do i = 0,dimsizes(vc_res_index)-1
                    vcres@$attnames(vc_res_index(i))$ = res2@$attnames(vc_res_index(i))$
                end do
                attsetvalues(plot_object,vcres)
            end if
            if(force_xaxis_linear.or.force_xaxis_log.or. \
               force_yaxis_linear.or.force_yaxis_log)
              tr_res_index = ind(chartostring(res(:,0:1)).eq."tr")
              if(.not.all(ismissing(tr_res_index)))
                  trres = True
                  do i = 0,dimsizes(tr_res_index)-1
                    trres@$attnames(tr_res_index(i))$ = res2@$attnames(tr_res_index(i))$
                  end do
              end if
            end if
        end if
    end if

;
; If gsnShape was set to True, then resize the X or Y axis so that
; the scales are proportionally correct.
; 
    if(shape)
        getvalues plot_object
          "vpXF"      : xf
          "vpYF"      : yf
          "vpWidthF"  : width
          "vpHeightF" : height
          "trXMinF"   : trxmin
          "trXMaxF"   : trxmax
          "trYMinF"   : trymin
          "trYMaxF"   : trymax
        end getvalues

        xrange = trxmax - trxmin
        yrange = trymax - trymin

        if(xrange.lt.yrange)
          new_width  = width * (xrange/yrange)
          new_height = height
          new_xf     = xf + 0.5*(width-new_width)
          new_yf     = yf
        else
          new_height = height * (yrange/xrange)
          new_width  = width
          new_yf     = yf - 0.5*(height-new_height)
          new_xf     = xf
        end if

        setvalues plot_object
          "vpXF"      : new_xf
          "vpYF"      : new_yf
          "vpWidthF"  : new_width
          "vpHeightF" : new_height
        end setvalues
    end if

;
; If gsnScale was set to True, then make sure the X and Y axis labels
; and tick marks are the same size.
; 
    if(scale)
        getvalues plot_object
          "tiXAxisFontHeightF"   : xfontf
          "tiYAxisFontHeightF"   : yfontf
          "tmXBLabelFontHeightF" : xbfontf
          "tmXBMajorLengthF"     : xlengthf
          "tmXBMinorLengthF"     : xmlengthf
          "tmYLLabelFontHeightF" : ylfontf
          "tmYLMajorLengthF"     : ylengthf
          "tmYLMinorLengthF"     : ymlengthf
        end getvalues

        setvalues plot_object
          "tiXAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tiYAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tmXBLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmXBMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmXBMinorLengthF"     : (ymlengthf+xmlengthf)/2.
          "tmYLLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmYLMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmYLMinorLengthF"     : (ymlengthf+xmlengthf)/2.
        end setvalues
    end if

; Check if we need to force the X or Y axis to be linear or log.
; If so, then we have to overlay it on a LogLin Plot.

     if(force_xaxis_linear.or.force_xaxis_log.or. \
        force_yaxis_linear.or.force_yaxis_log)

       overlay_plot_object = plot_object
       delete(plot_object)

       getvalues overlay_plot_object
         "trXMinF"    : trxmin
         "trXMaxF"    : trxmax
         "trYMinF"    : trymin
         "trYMaxF"    : trymax
       end getvalues

      plot_object = create wksname + "_loglin" logLinPlotClass wks
        "trXLog"  : force_xaxis_log
        "trYLog"  : force_yaxis_log
        "trXMinF" : trxmin
        "trXMaxF" : trxmax
        "trYMinF" : trymin
        "trYMaxF" : trymax
      end create
      if(trres)
        attsetvalues(plot_object,trres)
      end if

      overlay(plot_object,overlay_plot_object)
      plot_object@contour = overlay_plot_object
    end if

    if(calldraw)
        draw(plot_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object and data object (as attribute of plot object).

    plot_object@vfdata = vfdata_object
    plot_object@sfdata = sfdata_object
    return(plot_object)
end

;***********************************************************************;
; Function : gsn_vector_scalar_map                                      ;
;                   wks: workstation object                             ;
;                     u: 2-dimensional U data                           ;
;                     v: 2-dimensional V data                           ;
;                  data: 2-dimensional scalar field                     ;
;               resources: optional resources                           ;
;                                                                       ;
; This function creates and draws a vector plot over a map plot to the  ;
; workstation "wks" (the variable returned from a previous call to      ;
; "gsn_open_wks").  "u" and "v" are the 2-dimensional arrays to be      ;
; vectorized, and "data" is the scalar field that the vectors are       ;
; colored by. "resources" is an optional list of resources. The id of   ;
; the map plot is returned.                                             ;
;***********************************************************************;

function gsn_vector_scalar_map(wks:graphic,u[*][*]:numeric,\
                               v[*][*]:numeric,data[*][*]:numeric,\
                               resources:logical)
local i, attnames, vfdata_object, sfdata_object, contour_object, res, \
vf_res_index, vc_res_index, sf_res_index, mp_res_index, map_object, res2
begin
    calldraw = True
    callframe = True
    scale     = False
    res2      = resources
;
; Create the vector field object.
;
    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    vfdata_object = create wksname + "_vfdata" vectorFieldClass noparent
        "vfUDataArray" : u
        "vfVDataArray" : v
    end create

;
; Check for missing values.
;
    if(isatt(u,"_FillValue")) then
        setvalues vfdata_object
            "vfMissingUValueV" :u@_FillValue
        end setvalues
    end if
    if(isatt(v,"_FillValue")) then
        setvalues vfdata_object
            "vfMissingVValueV" :v@_FillValue
        end setvalues
    end if

; Create the scalar field object.

    sfdata_object = create wksname + "_sfdata" scalarFieldClass noparent
        "sfDataArray" : data
    end create

; Check for a missing value.

    if(isatt(data,"_FillValue")) then
        setvalues sfdata_object
            "sfMissingValueV" :data@_FillValue
        end setvalues
    end if

; Create plot object.

    vector_object = create wksname + "_vector" vectorPlotClass wks
        "vcVectorFieldData" : vfdata_object
        "vcScalarFieldData" : sfdata_object
        "vcUseScalarArray"  : True
        "vcMonoLineArrowColor"  : "false"
    end create

; Create map object.

    map_object = create wksname + "_map" mapPlotClass wks end create

    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False
            end if
            delete(res2@gsnDraw)
        end if
        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

        if(isatt(res2,"gsnScale"))
            if(res2@gsnScale)
                scale = True
            end if
            delete(res2@gsnScale)
        end if
    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
; Get list of resources.

        attnames = getvaratts(res2)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))
        if(dimsizes(dimsizes(res)).eq.1)

;***********************************************************************;
; Check to see if any resources were set. For the vector field data     ;
; object, resources begin with "vf" and for the scalar field data       ;
; object, resources being with "sf". For the map object, resources begin;
; with "mp". For the vector object, any resource that doesn't start with;
; "mp" or "vf" is assumed to be a vector or vector-related resource.    ;
;***********************************************************************;

            if(chartostring(res(0:1)).eq."vf")
                setvalues vfdata_object
                    attnames : res2@$attnames$
                end setvalues
            else
                if(chartostring(res(0:1)).eq."sf")
                    setvalues sfdata_object
                        attnames : res2@$attnames$
                    end setvalues
                else
                    if(chartostring(res(0:1)).eq."mp".or.\
                       chartostring(res(0:1)).eq."vp")
                        setvalues map_object
                            attnames : res2@$attnames$
                        end setvalues
                    else 
                        setvalues vector_object
                        attnames : res2@$attnames$
                        end setvalues
                    end if
                end if
            end if
        else
            vf_res_index = ind(chartostring(res(:,0:1)).eq."vf")
            sf_res_index = ind(chartostring(res(:,0:1)).eq."sf")
            mp_res_index = ind(chartostring(res(:,0:1)).eq."mp".or.\
                               chartostring(res(:,0:1)).eq."vp")
            vc_res_index = ind(chartostring(res(:,0:1)).ne."mp".and.\
                               chartostring(res(:,0:1)).ne."vf".and.\
                               chartostring(res(:,0:1)).ne."sf".and.\
                               chartostring(res(:,0:1)).ne."vp")
            if(.not.all(ismissing(vf_res_index)))
                vfres = True
                do i = 0,dimsizes(vf_res_index)-1
                    vfres@$attnames(vf_res_index(i))$ = res2@$attnames(vf_res_index(i))$
                end do
                attsetvalues(vfdata_object,vfres)
            end if
            if(.not.all(ismissing(sf_res_index)))
                sfres = True
                do i = 0,dimsizes(sf_res_index)-1
                    sfres@$attnames(sf_res_index(i))$ = res2@$attnames(sf_res_index(i))$
                end do
                attsetvalues(sfdata_object,sfres)
            end if
            if(.not.all(ismissing(mp_res_index)))
                mpres = True
                do i = 0,dimsizes(mp_res_index)-1
                    mpres@$attnames(mp_res_index(i))$ = res2@$attnames(mp_res_index(i))$
                end do
                attsetvalues(map_object,mpres)
            end if
            if(.not.all(ismissing(vc_res_index)))
                vcres = True
                do i = 0,dimsizes(vc_res_index)-1
                    vcres@$attnames(vc_res_index(i))$ = res2@$attnames(vc_res_index(i))$
                end do
                attsetvalues(vector_object,vcres)
            end if
        end if
    end if

    overlay(map_object,vector_object)

;
; If gsnScale was set to True, then make sure the X and Y axis labels
; and tick marks are the same size.
; 
    if(scale)
        getvalues vector_object
          "tiXAxisFontHeightF"   : xfontf
          "tiYAxisFontHeightF"   : yfontf
          "tmXBLabelFontHeightF" : xbfontf
          "tmXBMajorLengthF"     : xlengthf
          "tmXBMinorLengthF"     : xmlengthf
          "tmYLLabelFontHeightF" : ylfontf
          "tmYLMajorLengthF"     : ylengthf
          "tmYLMinorLengthF"     : ymlengthf
        end getvalues

        setvalues vector_object
          "tiXAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tiYAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tmXBLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmXBMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmXBMinorLengthF"     : (ymlengthf+xmlengthf)/2.
          "tmYLLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmYLMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmYLMinorLengthF"     : (ymlengthf+xmlengthf)/2.
        end setvalues
    end if

    if(calldraw)
        draw(map_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object and data object (as attribute of plot object).

    map_object@vfdata = vfdata_object
    map_object@sfdata = sfdata_object
    map_object@vector = vector_object
    return(map_object)
end

;***********************************************************************;
; Function : gsn_xy                                                     ;
;                   wks: workstation object                             ;
;                     x: n-dimensional array of X arrays                ;
;                     y: n-dimensional array of Y array                 ;
;             resources: optional resources                             ;
;                                                                       ;
; This function creates and draws an xy plot to the workstation "wks"   ;
; (the variable returned from a previous call to "gsn_open_wks").  "x"  ;
; and "y" are either 1 or 2-dimensional arrays containing the X and Y   ;
; data points and "resources" is an optional list of resources. The id  ;
; of the xy plot is returned.                                           ;
;***********************************************************************;

function gsn_xy(wks:graphic, x:numeric, y:numeric, resources:logical )
local i, attnames, data_object, plot_object, res, ca_res_index, \
xy_res_index, xydp_res_index, dspec, res2
begin
    calldraw  = True
    callframe = True
    scale     = False
    shape     = False
    res2      = resources

; Determine if we have multiple lines or just one line.

    nxdims = dimsizes(dimsizes(x))
    xdims = dimsizes(x)
    if(isatt(wks,"name"))
      wksname = wks@name
    else
      wksname = "gsnapp"
    end if

    data_object = create wksname + "_data" coordArraysClass noparent
        "caXArray" : x
        "caYArray" : y
    end create

; Check for missing values.

    if(isatt(x,"_FillValue")) then
        setvalues data_object
            "caXMissingV" :x@_FillValue
        end setvalues
    end if
    if(isatt(y,"_FillValue")) then
        setvalues data_object
            "caYMissingV" :y@_FillValue
        end setvalues
    end if

; Create plot object.

    plot_object = create wksname + "_xy" xyPlotClass wks
        "xyCoordData" : data_object
    end create

; Check for existence of x@long_name and y@long_name and use them
; to label X and Y axes.

    if(isatt(x,"long_name")) then
        setvalues plot_object
            "tiXAxisString" : x@long_name
        end setvalues
    end if
    if(isatt(y,"long_name")) then
        setvalues plot_object
            "tiYAxisString" : y@long_name
        end setvalues
    end if

; By default, only solid lines get drawn if there are multiple lines, so
; set some dash patterns to use instead.  Also set different marker styles.

    getvalues plot_object
        "xyCoordDataSpec" : dspec
    end getvalues

    setvalues dspec
        "xyDashPatterns" : (/0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,\
                             0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,\
                             0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16/)
    end setvalues
    if((res2).and..not.any(ismissing(getvaratts(res2))))

; Check if frame and/or draw are not supposed to be called.

        if(isatt(res2,"gsnDraw"))
            if(.not.res2@gsnDraw)
                calldraw = False
            end if
            delete(res2@gsnDraw)
        end if
        if(isatt(res2,"gsnFrame"))
            if(.not.res2@gsnFrame)
                callframe = False
            end if
            delete(res2@gsnFrame)
        end if

; Check if the plot should be reshaped or scaled.
 
       if(isatt(res2,"gsnScale"))
            if(res2@gsnScale)
                scale = True
            end if
            delete(res2@gsnScale)
        end if

        if(isatt(res2,"gsnShape"))
            if(res2@gsnShape)
                shape = True
                scale = True
            end if
            delete(res2@gsnShape)
        end if

; Check if turning tickmarks off.

        if(isatt(res2,"gsnTickMarksOn"))
            if(.not.res2@gsnTickMarksOn)
              gsnp_turn_off_tickmarks(res2)
            end if
            delete(res2@gsnTickMarksOn)
        end if

    end if

    if((res2).and..not.any(ismissing(getvaratts(res2))))
; Get list of resources.

        attnames = getvaratts(res2)
        res = stringtochar(attnames(ind(attnames.ne."_FillValue")))

; Check to see if any data resources were set (these are resources that
; start with the two-letter index "ca").

        if(dimsizes(dimsizes(res)).eq.1)
            if(chartostring(res(0:1)).eq."ca")
                setvalues data_object
                    attnames : res2@$attnames$
                end setvalues
            end if
        else
            ca_res_index = ind(chartostring(res(:,0:1)).eq."ca")
            if(.not.all(ismissing(ca_res_index)))
                cares = True
                do i = 0,dimsizes(ca_res_index)-1
                    cares@$attnames(ca_res_index(i))$ = res2@$attnames(ca_res_index(i))$
                end do
                attsetvalues(data_object,cares)
            end if
        end if

;***********************************************************************;
; Check to see if any xy plot resources were set.  There are two kinds  ;
; of xy plot resources, the regular kind, and the data spec kind.  If   ;
; the resource starts with an "xy", it could be either kind, so we need ;
; to have some tests to see which object it belongs to.  Any "xy"       ;
; resources that start with "xyCo", "xyX", or "xyY" are regular         ;
; resources (meaning, it belongs to the XyPlot object). The remaining   ;
; "xy" resources belong to the data spec object. Any resources that do  ;
; not start with "xy" or "ca" are assumed to also go with the XyPlot    ;
; object.                                                               ;
;***********************************************************************;

        if(dimsizes(dimsizes(res)).eq.1)
            if((chartostring(res(0:1)).ne."ca".and.\
                chartostring(res(0:1)).ne."xy").or.\
               (chartostring(res(0:1)).eq."xy".and.\
               (chartostring(res(0:3)).eq."xyCo".or.\
                chartostring(res(0:2)).eq."xyX".or.\
                chartostring(res(0:2)).eq."xyY")))
                setvalues plot_object
                    attnames : res2@$attnames$
                end setvalues
            end if
            if(chartostring(res(0:1)).eq."xy".and.\
              (chartostring(res(0:3)).ne."xyCo".and.\
               chartostring(res(0:2)).ne."xyX".and.\
               chartostring(res(0:2)).ne."xyY"))
                setvalues dspec
                    attnames : res2@$attnames$
                end setvalues
            end if
        else
            xy_res_index = ind((chartostring(res(:,0:1)).ne."ca".and.\
                                chartostring(res(:,0:1)).ne."xy").or.\
                               (chartostring(res(:,0:1)).eq."xy".and.\
                               (chartostring(res(:,0:3)).eq."xyCo".or.\
                                chartostring(res(:,0:2)).eq."xyX".or.\
                                chartostring(res(:,0:2)).eq."xyY")))
            xydp_res_index = ind(chartostring(res(:,0:1)).eq."xy".and.\
                                (chartostring(res(:,0:3)).ne."xyCo".and.\
                                 chartostring(res(:,0:2)).ne."xyX".and.\
                                 chartostring(res(:,0:2)).ne."xyY"))
            if(.not.all(ismissing(xy_res_index)))
                xyres = True
                do i = 0,dimsizes(xy_res_index)-1
                    xyres@$attnames(xy_res_index(i))$ = res2@$attnames(xy_res_index(i))$
                end do
                attsetvalues(plot_object,xyres)
            end if
            if(.not.all(ismissing(xydp_res_index)))
                getvalues plot_object
                    "xyCoordDataSpec" : dspec
                end getvalues
                xydpres = True
                do i = 0,dimsizes(xydp_res_index)-1
                    xydpres@$attnames(xydp_res_index(i))$ = res2@$attnames(xydp_res_index(i))$
                end do
                attsetvalues(dspec,xydpres)
            end if
        end if

    end if
;
; If gsnShape was set to True, then resize the X or Y axis so that
; the scales are proportionally correct.
; 
    if(shape)
        getvalues plot_object
          "vpXF"      : xf
          "vpYF"      : yf
          "vpWidthF"  : width
          "vpHeightF" : height
          "trXMinF"   : trxmin
          "trXMaxF"   : trxmax
          "trYMinF"   : trymin
          "trYMaxF"   : trymax
        end getvalues

        xrange = trxmax - trxmin
        yrange = trymax - trymin

        if(xrange.lt.yrange)
          new_width  = width * (xrange/yrange)
          new_height = height
          new_xf     = xf + 0.5*(width-new_width)
          new_yf     = yf
        else
          new_height = height * (yrange/xrange)
          new_width  = width
          new_yf     = yf - 0.5*(height-new_height)
          new_xf     = xf
        end if

        setvalues plot_object
          "vpXF"      : new_xf
          "vpYF"      : new_yf
          "vpWidthF"  : new_width
          "vpHeightF" : new_height
        end setvalues
    end if

;
; If gsnScale was set to True, then make sure the X and Y axis labels
; and tick marks are the same size.
; 
    if(scale)
        getvalues plot_object
          "tiXAxisFontHeightF"   : xfontf
          "tiYAxisFontHeightF"   : yfontf
          "tmXBLabelFontHeightF" : xbfontf
          "tmXBMajorLengthF"     : xlengthf
          "tmXBMinorLengthF"     : xmlengthf
          "tmYLLabelFontHeightF" : ylfontf
          "tmYLMajorLengthF"     : ylengthf
          "tmYLMinorLengthF"     : ymlengthf
        end getvalues

        setvalues plot_object
          "tiXAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tiYAxisFontHeightF"   : (xfontf+yfontf)/2.
          "tmXBLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmXBMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmXBMinorLengthF"     : (ymlengthf+xmlengthf)/2.
          "tmYLLabelFontHeightF" : (xbfontf+ylfontf)/2.
          "tmYLMajorLengthF"     : (ylengthf+xlengthf)/2.
          "tmYLMinorLengthF"     : (ymlengthf+xmlengthf)/2.
        end setvalues
    end if

    if(calldraw)
        draw(plot_object)
    end if

    if(callframe)
        frame(wks)
    end if

; Return plot object and data object (as attribute of plot object).

    plot_object@data = data_object
    return(plot_object)
end

