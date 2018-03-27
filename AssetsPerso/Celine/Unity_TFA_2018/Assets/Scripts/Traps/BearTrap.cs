using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BearTrap : MonoBehaviour
{    
    
    public float Duration = 2f;
    private float duration;

    public GameObject LaserGroup;
    private bool Triggered = false;
    
    void Start()
    {
        LaserGroup.SetActive(false);
        duration = Duration;
        Triggered = false;
    }


    void Update()
    {
        if(Triggered == true)
        {
            LaserGroup.SetActive(true);
            duration -= Time.deltaTime;
            Player.Current.MoveSpeed = 0f;
            if(duration < 0f)
            {
                Player.Current.MoveSpeed = 5f;
                LaserGroup.SetActive(false);
            }

        }
    }

    public void OnTriggerExit(Collider other)
    {
        if (Triggered == false) //&& other.gameObject.layer == LayerMask.NameToLayer("BearTrap")
        {
            Triggered = true;
        }
    }
}
