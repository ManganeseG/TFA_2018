using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MortalFog : MonoBehaviour
{
    private ParticleSystem ps;
    private bool enter;
    private bool inPoison;

    public float dotTime = 3.0f;

    public int FogDamage;

    float damageTimer = 0;

    // Use this for initialization
    void Start ()
    {
        ps = GetComponent<ParticleSystem>();
        var trigger = ps.trigger;
        trigger.enabled = true;
    }
	
	// Update is called once per frame
	void Update ()
    {
        var trigger = ps.trigger;
        trigger.enter = enter ? ParticleSystemOverlapAction.Callback : ParticleSystemOverlapAction.Ignore;
    }

    void OnTriggerEnter(Collider col)
    {
        if (col.gameObject.layer == LayerMask.NameToLayer("Player"))
        {
            enter = true;
            Debug.Log("Enter");
        }
    }
    void OnTriggerExit(Collider col)
    {
        if (col.gameObject.layer == LayerMask.NameToLayer("Player"))
        {
            enter = false;
            Debug.Log("Exit");
        }
    }

    void OnParticleTrigger()
    {

        if(enter)
        {
            List<ParticleSystem.Particle> enterList = new List<ParticleSystem.Particle>();
            int numEnter = ps.GetTriggerParticles(ParticleSystemTriggerEventType.Enter,enterList);
            
            if(numEnter != 0 && !inPoison)
            {
                StartCoroutine(DoPoisonDamage(dotTime, 4, FogDamage));
                Debug.Log("You are in the poison !");
            }
        }
    }

    IEnumerator DoPoisonDamage(float damageDuration, int damageCount, int damageAmount)
    {
        inPoison = true;
        int currentCount = 0;
        while (currentCount < damageCount)
        {
            HealthBar.Current.TakeDamage(damageAmount);
            Debug.Log(HealthBar.Current.Hp);
            yield return new WaitForSeconds(damageDuration);
            currentCount++;
        }
        inPoison = false;
    }
}



