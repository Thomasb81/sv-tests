/*
:name: class_test_19
:description: Test
:tags: 6.15 8.3
*/
package Package;
class Bar #(int X=0, int Y=1, int Z=2); endclass
endpackage
localparam x=3, y=4, z=5;

class Foo extends Package::Bar #(x,y,z); endclass
