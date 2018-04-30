// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "HEAJ/PostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_DistortionIngtensity("DistortionIngtensity", Range( 0 , 1)) = 0.2
		_DistortionCurve("DistortionCurve", Range( 0 , 2)) = 0
	}

	SubShader
	{
		
		
		ZTest Always
		Cull Off
		ZWrite Off
		

		Pass
		{ 
			CGPROGRAM 

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _DistortionIngtensity;
			uniform float _DistortionCurve;

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos ( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv6 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 _Vector0 = float2(0.5,0.5);
				float temp_output_7_0 = distance( uv6 , _Vector0 );
				float smoothstepResult9 = smoothstep( 0.9 , 0.1 , temp_output_7_0);
				float3 desaturateInitialColor3 = tex2D( _MainTex, ( uv6 + ( _DistortionIngtensity * ( uv6 - _Vector0 ) * ( pow( temp_output_7_0 , _DistortionCurve ) + 0 ) ) ) ).rgb;
				float desaturateDot3 = dot( desaturateInitialColor3, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar3 = lerp( desaturateInitialColor3, desaturateDot3.xxx, 1 );
				

				finalColor = float4( ( smoothstepResult9 * desaturateVar3 ) , 0.0 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15201
183;29;1370;1004;1221.395;188.7238;1;True;True
Node;AmplifyShaderEditor.Vector2Node;8;-1270.662,-84.9998;Float;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1286.764,-251.952;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-749.3259,153.6018;Float;False;Property;_DistortionCurve;DistortionCurve;2;0;Create;True;0;0;False;0;0;0.1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;7;-875.9017,-127.2259;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;14;-423.8983,130.864;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-143.9953,416.8139;Float;False;Property;_DistortionIngtensity;DistortionIngtensity;1;0;Create;True;0;0;False;0;0.2;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-188.0219,250.22;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;10;-21.09336,621.5806;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;175.5108,511.6116;Float;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;380.8088,430.1281;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;406.1618,74.97595;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;609.3483,69.14845;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;3;976.1946,127.4508;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;9;278.052,-260.0119;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.9;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;1237.275,-141.9986;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;4;893.4149,-88.27087;Float;False;Property;_Color0;Color 0;0;0;Create;True;0;0;False;0;0,0,0,0;0.9558824,0.1054282,0.1054282,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1420.461,-137.6458;Float;False;True;2;Float;ASEMaterialInspector;0;1;HEAJ/PostProcess;c71b220b631b6344493ea3cf87110c93;0;0;SubShader 0 Pass 0;1;False;False;True;Off;False;False;True;2;True;7;False;True;0;False;0;0;0;False;False;False;False;False;False;False;False;False;True;2;0;0;0;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;14;0;7;0
WireConnection;14;1;15;0
WireConnection;16;0;14;0
WireConnection;10;0;6;0
WireConnection;10;1;8;0
WireConnection;12;0;11;0
WireConnection;12;1;10;0
WireConnection;12;2;16;0
WireConnection;13;0;6;0
WireConnection;13;1;12;0
WireConnection;1;0;2;0
WireConnection;1;1;13;0
WireConnection;3;0;1;0
WireConnection;9;0;7;0
WireConnection;5;0;9;0
WireConnection;5;1;3;0
WireConnection;0;0;5;0
ASEEND*/
//CHKSM=5CC48F3A373B3D01A5BF3556D6F6590E88C24ED4