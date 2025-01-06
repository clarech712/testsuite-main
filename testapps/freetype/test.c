#include <stdio.h>
#include <ft2build.h>
#include FT_FREETYPE_H

int main() {
    FT_Library library;
    FT_Face face;
    const char* font_file = "/cluster/home/kchura01/testsuite-main/testapps/freetype/Arial.ttf"; // Path to a TTF font

    // Initialize FreeType library
    if (FT_Init_FreeType(&library)) {
        printf("Could not initialize FreeType library\n");
        return 1;
    }

    // Load the font face
    if (FT_New_Face(library, font_file, 0, &face)) {
        printf("Could not load font\n");
        return 1;
    }

    // Print font family name
    printf("Font family: %s\n", face->family_name);

    // Clean up
    FT_Done_Face(face);
    FT_Done_FreeType(library);

    return 0;
}

