function [Igray, filename] = Image2CHeader(Image, ResultsRef, DestinationFolder, ImagneName, decOrHex)

    I = Image;
    imageName = ImagneName;
    pixel_type = 'unsigned char';
    
    [h,w,c] = size(I);
    [hr,wr,cr] = size(ResultsRef);

    if (c>1)
        Igray = rgb2gray(I);
        c = 1;
    else
        Igray = I;
    end
    
    img_width = w;
    img_height = h;
    img_bpp = c;

    numberOfLines = img_width;
    fspec1 = cell(1,numberOfLines);
    fspec2 = cell(1,numberOfLines);
    
    if (~isempty(ResultsRef))
        if (cr>1)
            IRefgray = rgb2gray(ResultsRef);
            cr=1;
        else
            IRefgray = ResultsRef;
        end
        
        img_rwidth = wr;
        img_rheight = hr;
        img_rbpp = cr;
        numberOfLinesr = img_rwidth;
        fspec1r = cell(1,numberOfLinesr);
        fspec2r = cell(1,numberOfLinesr);
    else
        IRefgray = [];
    end

    
    
    if (decOrHex == 0)
        fspec1(1,1) = {'\t\t%3d,'};
        fspec1(1,2:end-1) = {'%3d,'};
        fspec1(1,end) = {'%3d,\n'};
        fspec2(1,end) = {'%3d\n'};
        if (~isempty(IRefgray))
            fspec1r(1,1) = {'\t\t%3d,'};
            fspec1r(1,2:end-1) = {'%3d,'};
            fspec1r(1,end) = {'%3d,\n'};
            fspec2r(1,end) = {'%3d\n'};
        end
    else
        fspec1(1,1) = {'\t\t0x%02X,'};
        fspec1(1,2:end-1) = {'0x%02X,'};
        fspec1(1,end) = {'0x%02X,\n'};
        fspec2(1,end) = {'0x%02X\n'};
        if (~isempty(IRefgray))
            fspec1r(1,1) = {'\t\t0x%02X,'};
            fspec1r(1,2:end-1) = {'0x%02X,'};
            fspec1r(1,end) = {'0x%02X,\n'};
            fspec2r(1,end) = {'0x%02X\n'};
        end 
    end

    fspec2(1,1) = fspec1(1,1);
    fspec2(1,2:end-1) = fspec1(1,2:end-1);
    if (~isempty(IRefgray))
        fspec2r(1,1) = fspec1r(1,1);
        fspec2r(1,2:end-1) = fspec1r(1,2:end-1);
    end
    
    prefix = strcat(upper(imageName));
    filename = fullfile(DestinationFolder, strcat(imageName,'.h'));

    fid = fopen(filename, 'w');
    
    fprintf(fid,'/* Generated file: %s.h */\n\n',  imageName);

    fprintf(fid,'#ifndef _%s_IMAGE_H_\n', prefix);
    fprintf(fid,'#define _%s_IMAGE_H_\n\n', prefix);

    fprintf(fid,'/* Image sizes definition */\n');
    fprintf(fid,'#define %s_IN_IMG_WIDTH %d\n', prefix, img_width);
    fprintf(fid,'#define %s_IN_IMG_HEIGHT %d\n', prefix, img_height);
    fprintf(fid,'#define %s_IN_IMG_BPP %d\n\n', prefix, img_bpp);
    
    if (~isempty(IRefgray))
        fprintf(fid,'#define %s_REF_IMG_WIDTH %d\n', prefix, img_rwidth);
        fprintf(fid,'#define %s_REF_IMG_HEIGHT %d\n', prefix, img_rheight);
        fprintf(fid,'#define %s_REF_IMG_BPP %d\n\n', prefix, img_rbpp);
    end

    fprintf(fid,'/* Image pixel type definition */\n');
    fprintf(fid,'#ifndef PIXEL_T_TYPE_DEFINITION\n');
    fprintf(fid,'#define PIXEL_T_TYPE_DEFINITION\n');
    fprintf(fid,'\ttypedef %s PIXEL_T;\n', pixel_type);
    fprintf(fid,'#endif //PIXEL_T_TYPE_DEFINITION\n\n');

    fprintf(fid,'/* Image struct type definition */\n');
    fprintf(fid,'#ifndef IMAGE_T_TYPE_DEFINITION\n');
    fprintf(fid,'#define IMAGE_T_TYPE_DEFINITION\n');
    
    fprintf(fid,'\ttypedef struct image_t\n');
    fprintf(fid,'\t{\n');
    fprintf(fid,'\t\tint width;\n');
    fprintf(fid,'\t\tint height;\n');
    fprintf(fid,'\t\tint bpp;\n');
    fprintf(fid,'\t\tconst PIXEL_T* data;\n');
    fprintf(fid,'\t} IMAGE_T;\n');
    fprintf(fid,'#endif //IMAGE_T_TYPE_DEFINITION\n\n');

    fprintf(fid,'\n/* Input Image content */\n');
    fprintf(fid,'static const PIXEL_T %s_IN_IMG_DATA[] = {\n', prefix);
    fprintf(fid,'//#IN_DATA_START\n');    
    fprintf(fid, cell2mat(fspec1),Igray((1:end-1), :)');
    fprintf(fid, cell2mat(fspec2),Igray(end,:)');
    fprintf(fid,'//#IN_DATA_FINISH\n');
    fprintf(fid,'};\n');
    
    if (~isempty(IRefgray))
        fprintf(fid,'\n/* Result Reference Image content */\n');
        fprintf(fid,'static const PIXEL_T %s_REF_IMG_DATA[] = {\n', prefix);
        fprintf(fid,'//#REF_DATA_START\n');    
        fprintf(fid, cell2mat(fspec1r),IRefgray((1:end-1), :)');
        fprintf(fid, cell2mat(fspec2r),IRefgray(end,:)');
        fprintf(fid,'//#REF_DATA_FINISH\n');
        fprintf(fid,'};\n');
    end
    
    fprintf(fid,'\n/* Initialized global input image object */\n');
    fprintf(fid,'static const IMAGE_T %sIn = {\n', imageName);
    fprintf(fid,'\t%s_IN_IMG_WIDTH,\n', prefix);
    fprintf(fid,'\t%s_IN_IMG_HEIGHT,\n', prefix);
    fprintf(fid,'\t%s_IN_IMG_BPP,\n', prefix);
    fprintf(fid,'\t&%s_IN_IMG_DATA[0]\n', prefix);
    fprintf(fid,'};\n');
    
    if (~isempty(IRefgray))
        fprintf(fid,'\n/* Initialized global result reference image object */\n');
        fprintf(fid,'static const IMAGE_T %sRes = {\n', imageName);
        fprintf(fid,'\t%s_REF_IMG_WIDTH,\n', prefix);
        fprintf(fid,'\t%s_REF_IMG_HEIGHT,\n', prefix);
        fprintf(fid,'\t%s_REF_IMG_BPP,\n', prefix);
        fprintf(fid,'\t&%s_REF_IMG_DATA[0]\n', prefix);
        fprintf(fid,'};\n');
    end
    
    fprintf(fid,'\n#endif //_%s_IMAGE_H_', prefix);

    fclose(fid);
end

