// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HEAJ/Celine/Effect01"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0
		_FoamColor("FoamColor", Color) = (0.8970588,0.5276816,0.5276816,0)
		_MainColor("MainColor", Color) = (0.03448248,0,1,0)
		_Roughness("Roughness", Range( 0 , 1)) = 0.5
		_Metalness("Metalness", Range( 0 , 1)) = 0
		_CutLimit("Cut Limit", Range( -2 , 3)) = 0.5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			fixed ASEVFace : VFACE;
		};

		uniform float4 _FoamColor;
		uniform float4 _MainColor;
		uniform float _CutLimit;
		uniform float _Metalness;
		uniform float _Roughness;
		uniform float _Cutoff = 0;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 _Vector0 = float3(0,1,0);
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult25 = dot( ase_worldNormal , ase_worldViewDir );
			float3 lerpResult27 = lerp( ase_vertexNormal , _Vector0 , step( dotResult25 , 1 ));
			float3 switchResult20 = (((o.ASEVFace>0)?(lerpResult27):(_Vector0)));
			v.normal = switchResult20;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_9_0 = ( _CutLimit - ase_vertex3Pos.y );
			float smoothstepResult14 = smoothstep( 0.15 , 0.25 , temp_output_9_0);
			float4 lerpResult16 = lerp( _FoamColor , _MainColor , smoothstepResult14);
			o.Albedo = lerpResult16.rgb;
			o.Metallic = _Metalness;
			o.Smoothness = ( 1.0 - _Roughness );
			o.Alpha = 1;
			clip( temp_output_9_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15201
626;318;1370;1004;573.9091;-122.0348;1.3;True;True
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;23;-99.73318,831.1012;Float;False;World;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;22;-106.8439,687.108;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;25;130.2623,773.5656;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-618.4044,392.2127;Float;False;Property;_CutLimit;Cut Limit;5;0;Create;True;0;0;False;0;0.5;0.5;-2;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;-541.43,252.6837;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;21;167.411,433.0266;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;19;183.6349,577.2368;Float;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StepOpNode;26;297.8266,772.1561;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;-275.9791,419.2386;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;14;-54.8292,205.912;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;451.8228,618.5063;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;15;-328.0559,-125.1522;Float;False;Property;_FoamColor;FoamColor;1;0;Create;True;0;0;False;0;0.8970588,0.5276816,0.5276816,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;-293.5512,-156.7894;Float;False;Property;_MainColor;MainColor;2;0;Create;True;0;0;False;0;0.03448248,0,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;196.4664,94.72419;Float;False;Property;_Roughness;Roughness;3;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-590.8485,800.3999;Float;False;266;229;Code pour avoir la postion relative au perso + world pos;1;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;12;-540.8485,850.3999;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwitchByFaceNode;20;495.1142,407.5692;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;5;475.3316,100.7971;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;360.984,17.18671;Float;False;Property;_Metalness;Metalness;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;18;304.0726,-147.4222;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-571.4512,491.1362;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;16;72.81963,-83.46936;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;665.9034,-33.57627;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;HEAJ/Celine/Effect01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Masked;0;True;True;0;False;TransparentCutout;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;22;0
WireConnection;25;1;23;0
WireConnection;26;0;25;0
WireConnection;9;0;7;0
WireConnection;9;1;11;2
WireConnection;14;0;9;0
WireConnection;27;0;21;0
WireConnection;27;1;19;0
WireConnection;27;2;26;0
WireConnection;20;0;27;0
WireConnection;20;1;19;0
WireConnection;5;0;4;0
WireConnection;18;0;15;0
WireConnection;18;1;1;0
WireConnection;16;0;15;0
WireConnection;16;1;1;0
WireConnection;16;2;14;0
WireConnection;0;0;16;0
WireConnection;0;3;2;0
WireConnection;0;4;5;0
WireConnection;0;10;9;0
WireConnection;0;12;20;0
ASEEND*/
//CHKSM=B95441BFD1509BBFBE35DF20011CD1B23BEEFA3F