with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;


package body Scene is

	R : Float := 50.0; -- coordonnee Z initiale de la camera
	Rho : Float := 0.0; -- rotation autour de X
	Theta : Float := 0.0; -- rotation autour de Y
	Phi : Float := 0.0; -- rotation autour de Z

	E : Vecteur(1..3) := (-400.0, -300.0, 400.0); -- position du spectateur
	T : Matrice(1..3, 1..3); -- matrice de rotation

	M : Maillage;

	procedure Modification_Matrice_Rotation is
	begin
	   
	   T := Matrice_Rotations ((1 => -Rho, 2 => -Theta, 3 => -Phi));
	   
	end Modification_Matrice_Rotation;
	
	procedure Modification_Matrice_Rotation_Inv is
	begin
	   
	   T := Matrice_Rotations_inverses ((1 => Rho, 2 => Theta, 3 => Phi));
	   
	end Modification_Matrice_Rotation_inv;
	

	function Position_Camera return Vecteur is
		Position : Vecteur(1..3);
	begin
	   -- a faire
	   -- au depart, point camera en (0,0,-R) (R>0)
	   Modification_Matrice_Rotation;
	   Position := (0.0, 0.0, -R);
	   Position := "*"( T, Position);
	   
	   New_Line;
	  -- New_Line;
	   --Put(Float'Rounding(Position(1)));
	   New_Line;
	   --Put(Float'Rounding(Position(2))); 
	   --New_Line;
	   --Put(Float'Rounding(Position(3)));
	   return Position;
	end;
	

	procedure Projection_Facette(Index_Facette : Positive ; P1, P2, P3 : out Vecteur) is
	   Cam : Vecteur(1..3);  
	begin
	  --Put(Index_Facette);
	  -- index_facette designe la facette selectionnee
	   Cam:=Position_Camera;
	   Modification_Matrice_Rotation_Inv;
	   
	   P3 := Projection(M(Index_Facette).P3,Cam, E, T); 
	   P2 := Projection(M(Index_Facette).P2, Cam, E, T); 
	   P1 := Projection(M(Index_Facette).P1, Cam, E, T); 
	   Put(P1(2));
	end Projection_Facette;
	
	
	procedure Ajout_Maillage(Maillage_Param : Maillage) is
	begin
	   -- Explication : cette proc est appellée par visualiseur.adb, et ce module appelle *déjà* chargement_ASCII. On a juste a copier le paramètre en mémoire.
	   -- Pour l'instant je copie TOUT le contenu du tableau, pas juste le pointeur. On verra ce que ca donne dans le reste, sinon on fait
	   -- M := M_Param
	   
	   M := new Tableau_Facette(Maillage_Param'Range);
	   
	   M.all := Maillage_Param.all;    	   
	   
	end;

	function Nombre_De_Facettes return Natural is
	begin
	   return M'Length;
	end;
	
	
	procedure Modification_Coordonnee_Camera(Index : Positive ; Increment : Float) is
	   procedure Indique_Mouvement(Index : Positive; Mouvement : Float) is
	   begin
	      case Index is
		 when 1 => Put_Line("Zoom de " & Float'Image(Mouvement));
		 when 2 => Put_Line("Rotation autour de Ox de " & Float'Image(Mouvement));
		 when 3 => Put_Line("Rotation autour de Oy de " & Float'Image(Mouvement));
		 when 4 => Put_Line("Rotation autour de Oz de " & Float'Image(Mouvement));
		 when others => null;
	      end case;
	      
	   end;

	 begin	 
	    -- index designe l'action voulu sur la camera
	    indique_Mouvement(Index, Increment);
	    
	 
	    if Index=1 then 
	       R:=R + Increment; 
	   elsif Index=4 then 
	      Phi:= Phi + Increment; --en radian	       
	   elsif Index=2 then
	      Rho:= Rho + Increment;	      
	   elsif Index=3 then 
	      Theta:= Theta + Increment;    
	   end if;
	   	        
	   
	   
	end Modification_Coordonnee_Camera;
	
	function Renvoi_Maillage return Maillage is
	begin
	   return M;
	end;

begin
   --initialisation de la matrice de rotation au lancement du programme  
   Modification_Matrice_Rotation;
end;
