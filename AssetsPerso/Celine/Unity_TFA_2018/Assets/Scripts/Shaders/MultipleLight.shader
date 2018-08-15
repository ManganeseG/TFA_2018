Shader "HEAJ/Celine/MultipleLight" 
{
   Properties {
      _MainTex ("Main Texture", Color) = (1,1,1,1) 
      _SpecColor ("Specular Material Color", Color) = (1,1,1,1) 
      _Shininess ("Shininess", Float) = 10
   }
   SubShader {
      Pass {      
         Tags { "LightMode" = "ForwardBase" }
 
         CGPROGRAM
         #pragma multi_compile_fwdbase 
         #pragma vertex vert
         #pragma fragment frag
 
         #include "UnityCG.cginc" 
         float4 _LightColor0;
 
         float4 _MainTex; 
         float4 _SpecColor; 
         float _Shininess;
 
         struct vertexInput {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 posWorld : TEXCOORD0;
            float3 normalDir : TEXCOORD1;
            float3 vertexLighting : TEXCOORD2;
         };
 
         vertexOutput vert(vertexInput input)
         {          
            vertexOutput output;
 
            float4x4 modelMatrix = unity_ObjectToWorld;
            float4x4 modelMatrixInverse = unity_WorldToObject; 
 
            output.posWorld = mul(modelMatrix, input.vertex);
            output.normalDir = normalize(mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
            output.pos = UnityObjectToClipPos(input.vertex);
           
            output.vertexLighting = float3(0.0, 0.0, 0.0);

            for (int index = 0; index < 4; index++)
            {    
               float4 lightPosition = float4(unity_4LightPosX0[index], unity_4LightPosY0[index], unity_4LightPosZ0[index], 1.0);
 
               float3 vertexToLightSource = lightPosition.xyz - output.posWorld.xyz;        
               float3 lightDirection = normalize(vertexToLightSource);
               float squaredDistance = dot(vertexToLightSource, vertexToLightSource);
               float attenuation = 1.0 / (1.0 + unity_4LightAtten0[index] * squaredDistance);
               float3 diffuseReflection = attenuation * unity_LightColor[index].rgb * _MainTex.rgb * max(0.0, dot(output.normalDir, lightDirection));         
 
               output.vertexLighting = output.vertexLighting + diffuseReflection;
            }

            return output;
         }
 
         float4 frag(vertexOutput input) : COLOR
         {
            float3 normalDirection = normalize(input.normalDir); 
            float3 viewDirection = normalize(_WorldSpaceCameraPos - input.posWorld.xyz);
            float3 lightDirection;
            float attenuation;
 
            if (0.0 == _WorldSpaceLightPos0.w)
            {
               attenuation = 1.0;
               lightDirection = normalize(_WorldSpaceLightPos0.xyz);
            } 
            else
            {
               float3 vertexToLightSource = 
                  _WorldSpaceLightPos0.xyz - input.posWorld.xyz;
               float distance = length(vertexToLightSource);
               attenuation = 1.0 / distance; //linear
               lightDirection = normalize(vertexToLightSource);
            }
 
            float3 ambientLighting = 
                UNITY_LIGHTMODEL_AMBIENT.rgb * _MainTex.rgb;
 
            float3 diffuseReflection = 
               attenuation * _LightColor0.rgb * _MainTex.rgb 
               * max(0.0, dot(normalDirection, lightDirection));
 
            float3 specularReflection;
            if (dot(normalDirection, lightDirection) < 0.0)
            {
               specularReflection = float3(0.0, 0.0, 0.0); 
            }
            else
            {
               specularReflection = attenuation * _LightColor0.rgb 
                  * _SpecColor.rgb * pow(max(0.0, dot(
                  reflect(-lightDirection, normalDirection), 
                  viewDirection)), _Shininess);
            }
 
            return float4(input.vertexLighting + ambientLighting 
               + diffuseReflection + specularReflection, 1.0);
         }
         ENDCG
      }
 
      Pass {    
         Tags { "LightMode" = "ForwardAdd" }
         Blend One One
 
          CGPROGRAM
 
         #pragma vertex vert  
         #pragma fragment frag 
 
         #include "UnityCG.cginc" 
         uniform float4 _LightColor0;
 

         float4 _MainTex; 
         float4 _SpecColor; 
         float _Shininess;
 
         struct vertexInput {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 posWorld : TEXCOORD0;
            float3 normalDir : TEXCOORD1;
         };
 
         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;
 
            float4x4 modelMatrix = unity_ObjectToWorld;
            float4x4 modelMatrixInverse = unity_WorldToObject; 
 
            output.posWorld = mul(modelMatrix, input.vertex);
            output.normalDir = normalize(mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
            output.pos = UnityObjectToClipPos(input.vertex);
            return output;
         }
 
         float4 frag(vertexOutput input) : COLOR
         {
            float3 normalDirection = normalize(input.normalDir);
 
            float3 viewDirection = normalize(
               _WorldSpaceCameraPos.xyz - input.posWorld.xyz);
            float3 lightDirection;
            float attenuation;
             if (0.0 == _WorldSpaceLightPos0.w)
            {
               attenuation = 1.0;
               lightDirection =normalize(_WorldSpaceLightPos0.xyz);
            } 
            else
            {
               float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - input.posWorld.xyz;
               float distance = length(vertexToLightSource);
               attenuation = 1.0 / distance;
               lightDirection = normalize(vertexToLightSource);
            }
            float3 diffuseReflection = attenuation * _LightColor0.rgb * _MainTex.rgb * max(0.0, dot(normalDirection, lightDirection));
             float3 specularReflection;
            if (dot(normalDirection, lightDirection) < 0.0) 
            {
               specularReflection = float3(0.0, 0.0, 0.0); 
            }
            else
            {
               specularReflection = attenuation * _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection),viewDirection)), _Shininess);
            }
			return float4(diffuseReflection + specularReflection, 1.0);
         }
 
         ENDCG
      }
 
   } 
   Fallback "Specular"
}