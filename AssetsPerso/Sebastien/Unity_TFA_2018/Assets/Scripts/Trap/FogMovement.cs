using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FogMovement : MonoBehaviour
{

    private float coolDownFog = 10.0f;

    public float NextFog;

    public ParticleSystem fogG;

    public bool isPlayingFog = false;

    void Update ()
    {
        
       if(Time.time > NextFog)
        {

            fogG.Play();

            NextFog = Time.time + coolDownFog;

            isPlayingFog = true;

            Debug.Log("Test");
        }

    }

    void FogMove()
    {
       
    }
}
