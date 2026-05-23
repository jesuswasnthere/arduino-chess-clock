$fn = 60;

// ==========================================
// VARIABLES DE TAMAÑO Y TOLERANCIA
// ==========================================
W = 140;  // Ancho total del reloj 
D = 110;  // Profundidad total 
H = 65;   // Alto total 
CW = W / 2; // Centro exacto del ancho 

tolerancia_tapa = 0.8; // Tolerancia para que la tapa encaje

// --- GROSOR Y ESP32-S2 MINI ---
grosor_tapa = 6;       
esp32_ancho = 25.4;    
esp32_largo = 34.3;    
esp32_prof = 3;        

// Medidas exactas de tus componentes
pantalla_ancho = 96;
pantalla_alto = 41;
corneta_diam = 47; 

boton_cuadrado = 6; 

// Medidas del panel trasero
usb_ancho = 10;  
usb_alto = 6;
suiche_ancho = 11; 
suiche_alto = 6;

// Soportes de la pantalla
pantalla_tornillos_ancho = 93; 
pantalla_tornillos_alto = 55;  

// ==========================================
// --- CUNA DEL BOTÓN (Pestañas entre patas) ---
// ==========================================
altura_torres = 46;      
boton_ancho = 11.4;      // 11mm exactos de tu botón + 0.4mm de tolerancia
boton_base_alto = 3.5;   // Altura de la caja negra del botón
recorrido_boton = 1.5;   // Recorrido libre antes del golpe

// ==========================================

// Hull
module backTopSides(){
    union() {
        difference(){
            difference() {
                cube([W, D, H]);
                translate([-5,0,0])
                rotate(a=53.13010235, v=[1,0,0])
                cube([W+10, D*1.5, H*1.5]); 
            }
            
            translate([3,0,-3])
            difference(){
                cube([W-6, D-3, H]);
                translate([-5,0,0])
                rotate(a=53.13010235, v=[1,0,0])
                cube([W+10, D*1.5, H*1.5]);
            }
            
            // Hueco del balancín
            translate([(W-87)/2, D-51, H-5])
            cube([87, 42, 10]);
            
            // Bisel delantero 
            translate([5, 4, 0])
            rotate(a=53.13010235, v=[1,0,0])
            cube([W-10, 80, 5]);
            
            // Hueco para la corneta 
            translate([-5, D-35, (H/2) + 2]) 
            rotate(a=90, v=[0,1,0]) 
            cylinder(h=15, d=corneta_diam, $fn=99);
            
            // Huecos Traseros
            translate([W/4, D - 5, 12]) 
            cube([usb_ancho, 10, usb_alto]);
            
            translate([(3*W/4) - suiche_ancho, D - 5, 12]) 
            cube([suiche_ancho, 10, suiche_alto]);
        }
        
        // Soportes del eje del balancín
        translate([CW-5, D-9, H-5]) cube([10, 6, 5]);
        translate([CW, D-9, H-5]) rotate(a=-90, v=[1,0,0]) cylinder(6, 5, 5, $fn=99);
        translate([CW-5, D-60, H-5]) cube([10, 9, 5]);
        translate([CW, D-60, H-5]) rotate(a=-90, v=[1,0,0]) cylinder(9, 5, 5, $fn=99);
    }
}

module hole(){
    difference(){
        cylinder(5, 2, 2, $fn=99);
        translate([0,0,-1.5]) cylinder(5, 1, 1, $fn=99);
    }
}

module front(){
    FRONT_L = 80; 
    union() {
        difference(){
            cube([W, FRONT_L, 3]);
            
            // 3 Huecos frontales 
            for (i = [-1 : 1 : 1]) {
                translate([CW + (i * 20) - (boton_cuadrado/2), 12 - (boton_cuadrado/2), -1])
                cube([boton_cuadrado, boton_cuadrado, 5]);
            }
                    
            // Hueco de tu pantalla LCD
            translate([CW - (pantalla_ancho/2), 24, -1]) cube([pantalla_ancho, pantalla_alto, 5]);
        }
        
        // Soportes de tornillos
        translate([15, FRONT_L-2.5, -3.5]) hole();
        translate([15, 14.5, -3.5]) hole();
        translate([W-15, FRONT_L-2.5, -3.5]) hole();
        translate([W-15, 14.5, -3.5]) hole();
        translate([15, 9, -3.5]) hole();
        translate([W-15, 9, -3.5]) hole();
        
        // 4 Soportes pantalla
        pantalla_centro_y = 24 + (pantalla_alto / 2); 
        
        translate([CW - (pantalla_tornillos_ancho/2), pantalla_centro_y - (pantalla_tornillos_alto/2), -3.5]) hole();
        translate([CW + (pantalla_tornillos_ancho/2), pantalla_centro_y - (pantalla_tornillos_alto/2), -3.5]) hole();
        translate([CW - (pantalla_tornillos_ancho/2), pantalla_centro_y + (pantalla_tornillos_alto/2), -3.5]) hole();
        translate([CW + (pantalla_tornillos_ancho/2), pantalla_centro_y + (pantalla_tornillos_alto/2), -3.5]) hole();
    }
}

module hull(){
    union() {
        difference(){
            backTopSides();
            
            translate([CW-2, D-10, H-4.5]) cube([4, 7, 5.5]);
            translate([CW, D-10, H-4.5]) rotate(a=-90, v=[1,0,0]) cylinder(7, 2, 2, $fn=99);
            translate([CW-2, D-57, H-4.5]) cube([4, 7, 5.5]);
            translate([CW, D-57, H-4]) rotate(a=-90, v=[1,0,0]) cylinder(7, 2, 2, $fn=99);   
        }
        translate([6, 60, H-7]) hole();
        translate([W-6, 60, H-7]) hole();
        
        rotate(a=53.13010235, v=[1,0,0]) translate([0,2,-3]) front();
    }
}

module switch(){
    union() {
        cube([42.5, 41, 6]);
        translate([43, 0, 0]) rotate(a=-8, v=[0,1,0]) cube([42.5, 41, 6]);
        translate([42.5, 46, 1.5]) rotate(a=90, v=[1,0,0]) cylinder(51, 1.5, 1.5, $fn=99);
    }
}

module cut(){
    points = [ 
    [3, D-3, 3],
    [W-3, D-3, 3],
    [3, D-3, 3 + grosor_tapa],
    [W-3, D-3, 3 + grosor_tapa],
    [3, D-5.25, 3 + grosor_tapa],
    [W-3, D-5.25, 3 + grosor_tapa]];
    faces = [
    [0,1,2],
    [2,1,3],
    [0,4,1],
    [1,4,5],
    [2,3,4],
    [3,5,4],
    [0,2,4],
    [1,5,3]];
    polyhedron(points,faces);
}

// ==========================================
// MÓDULO DE LA TORRE SNAP-FIT (Solo Cruz y Pestañas)
// ==========================================
module torre_protegida(es_izq) {
    h_torre = altura_torres - (grosor_tapa - 3); 
    espacio = boton_ancho; 
    grosor_tab = 2;
    w_t = espacio + (2 * grosor_tab); 
    d_t = espacio + grosor_tab;       
    ancho_p = 4; // Ancho de las pestañitas

    // 1. Pilar en forma de CRUZ (Deja las 4 esquinas vacías)
    translate([grosor_tab, 0, 0]) {
        // Soporte Y (Adelante-Atrás)
        translate([(espacio - ancho_p)/2, 0, 0]) cube([ancho_p, espacio, h_torre]);
        // Soporte X (Izquierda-Derecha)
        translate([0, (espacio - ancho_p)/2, 0]) cube([espacio, ancho_p, h_torre]);
    }

    // 2. Las Pestañitas de anclaje (dedos estrechos)
    translate([0, 0, h_torre]) {
        // Pestaña Izquierda
        translate([0, (espacio - ancho_p)/2, 0]) {
            cube([grosor_tab, ancho_p, boton_base_alto]); // Pared de la pestaña
            translate([grosor_tab, 0, boton_base_alto - 1]) cube([0.8, ancho_p, 1]); // Diente
        }

        // Pestaña Derecha
        translate([grosor_tab + espacio, (espacio - ancho_p)/2, 0]) {
            cube([grosor_tab, ancho_p, boton_base_alto]);
            translate([-0.8, 0, boton_base_alto - 1]) cube([0.8, ancho_p, 1]);
        }

        // Pestaña Trasera (Tope)
        translate([grosor_tab + (espacio - ancho_p)/2, espacio, 0]) {
            cube([ancho_p, grosor_tab, boton_base_alto]);
            translate([0, -0.8, boton_base_alto - 1]) cube([ancho_p, 0.8, 1]);
        }
    }
}

module bottom() {
    union() {
        difference(){
            translate([3 + (tolerancia_tapa/2), 3 + (tolerancia_tapa/2), 0]) 
            cube([W - 6 - tolerancia_tapa, D - 6.25 - tolerancia_tapa, grosor_tapa]); 
            
            translate([CW - (esp32_ancho/2) - 0.5, 25, grosor_tapa - esp32_prof])
            cube([esp32_ancho + 1, esp32_largo + 1, esp32_prof + 1]);
            
            translate([10,10,0]) cylinder(15,d=2,true);
            translate([W-10,10,0]) cylinder(15,d=2,true);
            translate([10,D-10,0]) cylinder(15,d=2,true);
            translate([W-10,D-10,0]) cylinder(15,d=2,true);
            
            translate([0, 0, -3]) cut();
        }
        
        translate([CW - 38, D - 42, grosor_tapa]) torre_protegida(true);
        translate([CW + 24, D - 42, grosor_tapa]) torre_protegida(false);
    }
}

module foot(x,y){
    h = 3;
    outR = 5;
    inR = 2;
    translate([x,y,0])
    difference(){
        cylinder(h,r=outR,true);
        cylinder(h,r=inR,true);
    }
}

module bottomWithFeet() {
    union() {
        translate([0,0,3]) bottom();
        foot(10,10);
        foot(W-10,10);
        foot(10,D-10);
        foot(W-10,D-10);
    }
}

// ==========================================
// --- PIEZAS SEPARADAS PARA IMPRESIÓN ---
// ==========================================

// 1. Carcasa principal
hull();

// 2. Balancín
translate([W + 20, 0, 0])
switch();

// 3. Base (Torres de cruz sin esquinas, Cuna ESP32)
translate([0, D + 20, 0])
bottomWithFeet();