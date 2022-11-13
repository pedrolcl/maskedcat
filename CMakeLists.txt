cmake_minimum_required(VERSION 3.16)

project(maskedcat VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick ShaderTools REQUIRED)

qt_add_executable(${PROJECT_NAME}
    "src/main.cpp"
)

set_source_files_properties(
    "qml/main.qml" PROPERTIES QT_RESOURCE_ALIAS "main.qml"
)

qt_add_qml_module(${PROJECT_NAME}
    URI "io.github.pedrolcl"
    VERSION 0.1
    QML_FILES "qml/main.qml"
    RESOURCE_PREFIX "/"
    NO_RESOURCE_TARGET_PATH
)

qt_add_resources(${PROJECT_NAME} "images"
    PREFIX "/"
    BASE "img/"
    FILES "img/Tabby_cat_with_blue_eyes.jpg"
)

qt_add_shaders(${PROJECT_NAME} "shaders"
    PREFIX "/"
    FILES 
        "shaders/opacitymask.frag"
        "shaders/gaussianblur.frag"
    OUTPUTS
        "opacitymask.frag.qsb"
        "gaussianblur.frag.qsb"
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE Qt6::Quick
)

install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
