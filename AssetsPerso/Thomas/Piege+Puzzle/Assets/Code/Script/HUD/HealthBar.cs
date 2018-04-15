using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HealthBar : MonoBehaviour 
{
    
    public static HealthBar Current
    {
        get { return current; }
    }
    public int Hp;
	public int HpMax=1000;
    [Range(0f, 1f)]
    public float SpeedHP = 1.0f;
    public int damages = 0;

	private Image healthbar;
    private static HealthBar current;
    float visualHP;

    private void Awake()
    {
        current = this;
    }

    void Start ()
	{
		healthbar = GetComponent<Image>();
		Hp = HpMax;
        visualHP = Hp;
    }

    private void Update()
    {
        visualHP = Mathf.Lerp(visualHP, Hp, SpeedHP * Time.deltaTime);
        healthbar.fillAmount = (float)visualHP / HpMax;

        Debug.Log(Hp + "     " + healthbar.fillAmount);
    }
    
    //Inflige des dégats
    public void TakeDamage(int damages)
	{
		Hp -= damages;
	}
	//Soigne le joueur
	public void Heal(int heal)
	{
		Hp += heal;
    }
	//Actualiser pdv
	private void UpdateHealth()
	{
        Hp = Mathf.Clamp(Hp, 0, HpMax);      
    }
}
